import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/orders_cubit.dart';
import '../models/order_model.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          final order = context.read<OrdersCubit>().findById(orderId);

          if (order == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 48, color: subTextColor),
                    const SizedBox(height: 12),
                    Text('Order not found.', style: TextStyle(color: subTextColor)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: const Text('Go to Home'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                order.id,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),

              // Live status timeline
              for (int i = 0; i < OrderStatus.values.length; i++)
                _StatusStep(
                  status: OrderStatus.values[i],
                  isCompleted: i <= order.status.index,
                  isCurrent: i == order.status.index,
                  isLast: i == OrderStatus.values.length - 1,
                ),

              const SizedBox(height: 24),

              // Mini map showing delivery pin
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  height: 180,
                  child: IgnorePointer(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(order.deliveryLatitude, order.deliveryLongitude),
                        initialZoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.interngrow.interngrow_food_delivery_app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(order.deliveryLatitude, order.deliveryLongitude),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_pin, color: AppColors.primary, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: subTextColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(order.deliveryAddress, style: TextStyle(color: subTextColor, fontSize: 13)),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Items (${order.totalItemCount})', style: TextStyle(color: subTextColor)),
                        Text('\$${(order.total + order.discountAmount).toStringAsFixed(2)}'),
                      ],
                    ),
                    if (order.discountAmount > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount (${order.couponCode})', style: const TextStyle(color: AppColors.success)),
                          Text('-\$${order.discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.success)),
                        ],
                      ),
                    ],
                    Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)),
                        Text(
                          '\$${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Back to Restaurants'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  final OrderStatus status;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const _StatusStep({
    required this.status,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final inactiveColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppColors.primary : inactiveColor,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? AppColors.primary : inactiveColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.label,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 15,
                      color: isCompleted ? null : subTextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(status.description, style: TextStyle(color: subTextColor, fontSize: 13)),
                  if (isCurrent) ...[
                    const SizedBox(height: 6),
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}