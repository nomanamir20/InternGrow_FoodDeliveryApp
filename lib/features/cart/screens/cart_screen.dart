import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/cart_cubit.dart';
import '../models/cart_item_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.items.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => _confirmClearCart(context),
                child: const Text('Clear'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 64, color: subTextColor),
                    const SizedBox(height: 16),
                    Text(
                      'Your cart is empty',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text('Add some tasty food to get started.', style: TextStyle(color: subTextColor)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: const Text('Browse Restaurants'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _CartItemTile(item: state.items[index]),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) return const SizedBox.shrink();

          final isDark = Theme.of(context).brightness == Brightness.dark;

          return SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: Border(
                  top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: TextStyle(color: subTextColor, fontSize: 15)),
                      Text(
                        '\$${state.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push(AppRoutes.address),
                      child: const Text('Proceed to Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmClearCart(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<CartCubit>().clearCart();
    }
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: item.meal.thumbnail,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(width: 72, height: 72, color: borderColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.meal.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.meal.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: () => context.read<CartCubit>().updateQuantity(item.meal.id, item.quantity - 1),
                    ),
                    Container(
                      width: 36,
                      alignment: Alignment.center,
                      child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    _QtyButton(
                      icon: Icons.add,
                      onTap: () => context.read<CartCubit>().updateQuantity(item.meal.id, item.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                onPressed: () => context.read<CartCubit>().removeFromCart(item.meal.id),
              ),
              Text(
                '\$${item.lineTotal.toStringAsFixed(2)}',
                style: TextStyle(color: subTextColor, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }
}