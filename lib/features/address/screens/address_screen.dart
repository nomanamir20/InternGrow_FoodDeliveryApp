import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../orders/cubit/orders_cubit.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/address_cubit.dart';
import '../models/address_model.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _mapController = MapController();
  final _locationService = LocationService();
  final _labelController = TextEditingController(text: 'Home');
  final _addressController = TextEditingController();

  // Default to a neutral starting point (Karachi, Pakistan) until the user
  // picks a location — arbitrary but reasonable given the internship context.
  LatLng _selectedLocation = const LatLng(24.8607, 67.0011);
  bool _isLocating = false;

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);

    final position = await _locationService.getCurrentPosition();

    if (!mounted) return;
    setState(() => _isLocating = false);

    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not access your location. Please check location permissions.'),
        ),
      );
      return;
    }

    final newLocation = LatLng(position.latitude, position.longitude);
    setState(() => _selectedLocation = newLocation);
    _mapController.move(newLocation, 16);
  }

   void _saveAddress() {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a delivery address')),
      );
      return;
    }

    final address = DeliveryAddress(
      id: 'addr-${DateTime.now().millisecondsSinceEpoch}',
      label: _labelController.text.trim().isEmpty ? 'Home' : _labelController.text.trim(),
      fullAddress: _addressController.text.trim(),
      latitude: _selectedLocation.latitude,
      longitude: _selectedLocation.longitude,
    );

    context.read<AddressCubit>().addAddress(address);

    final cartState = context.read<CartCubit>().state;
    final newOrderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    context.read<OrdersCubit>().createOrder(
          id: newOrderId,
          items: cartState.items,
          total: cartState.total,
          deliveryAddress: address.fullAddress,
          deliveryLatitude: address.latitude,
          deliveryLongitude: address.longitude,
        );

    context.read<CartCubit>().clearCart();

    context.go('${AppRoutes.orderTracking}/$newOrderId');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Address')),
      body: Column(
        children: [
          // Saved addresses quick-select
          BlocBuilder<AddressCubit, AddressState>(
            builder: (context, state) {
              if (state.savedAddresses.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: state.savedAddresses.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final addr = state.savedAddresses[index];
                    return ActionChip(
                      avatar: const Icon(Icons.location_on, size: 16),
                      label: Text(addr.label),
                      onPressed: () {
                        setState(() {
                          _selectedLocation = LatLng(addr.latitude, addr.longitude);
                          _addressController.text = addr.fullAddress;
                          _labelController.text = addr.label;
                        });
                        _mapController.move(_selectedLocation, 16);
                      },
                    );
                  },
                ),
              );
            },
          ),

          // Map — OpenStreetMap via flutter_map, free, no API key
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation,
                    initialZoom: 14,
                    onTap: (tapPosition, point) {
                      setState(() => _selectedLocation = point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.interngrow.interngrow_food_delivery_app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation,
                          width: 44,
                          height: 44,
                          child: const Icon(
                            Icons.location_pin,
                            color: AppColors.primary,
                            size: 44,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: FloatingActionButton.small(
                    heroTag: 'locate-me',
                    onPressed: _isLocating ? null : _useCurrentLocation,
                    child: _isLocating
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
          ),

          // Address form
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border(
                top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tap the map to set your delivery pin, or use your current location.',
                  style: TextStyle(color: subTextColor, fontSize: 12),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _labelController,
                  decoration: const InputDecoration(
                    labelText: 'Label',
                    hintText: 'Home, Work, etc.',
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Full Address',
                    hintText: 'Street, building, floor, landmark...',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    child: const Text('Confirm Address & Place Order'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}