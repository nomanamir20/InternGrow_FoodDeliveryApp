import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/services/meal_api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../models/meal_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String mealId;

  const ProductDetailsScreen({super.key, required this.mealId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _api = MealApiService();
  late Future<Meal?> _mealFuture;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _mealFuture = _api.fetchMealById(widget.mealId);
  }

  Future<void> _showAddedToCartDialog(BuildContext context, String mealName) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: AppColors.success, size: 48),
        title: const Text('Added to Cart'),
        content: Text('$mealName has been added to your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Continue Browsing'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go(AppRoutes.cart);
            },
            child: const Text('View Cart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      body: FutureBuilder<Meal?>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Could not load this item.', style: TextStyle(color: subTextColor)),
            );
          }

          final meal = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: meal.thumbnail,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.category.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      if (meal.area.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.public, size: 16, color: subTextColor),
                            const SizedBox(width: 4),
                            Text('${meal.area} cuisine', style: TextStyle(color: subTextColor)),
                          ],
                        ),
                      const SizedBox(height: 16),

                      Text(
                        '\$${meal.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                      ),
                      const SizedBox(height: 20),

                      if (meal.ingredients.isNotEmpty) ...[
                        Text(
                          'Ingredients',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (int i = 0; i < meal.ingredients.length; i++)
                              Chip(
                                label: Text(
                                  meal.measures[i].isNotEmpty
                                      ? '${meal.ingredients[i]} (${meal.measures[i]})'
                                      : meal.ingredients[i],
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                side: BorderSide(
                                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],

                      if (meal.instructions.isNotEmpty) ...[
                        Text(
                          'Preparation',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meal.instructions,
                          style: TextStyle(color: subTextColor, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                      ],

                      Text(
                        'Quantity',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _QuantityButton(
                            icon: Icons.remove,
                            onTap: _quantity > 1 ? () => setState(() => _quantity--) : null,
                          ),
                          Container(
                            width: 48,
                            alignment: Alignment.center,
                            child: Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                          ),
                          _QuantityButton(
                            icon: Icons.add,
                            onTap: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<Meal?>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) return const SizedBox.shrink();
          final meal = snapshot.data!;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<CartCubit>().addToCart(meal, quantity: _quantity);
                    _showAddedToCartDialog(context, meal.name);
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Add to Cart'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: onTap == null ? borderColor : null),
      ),
    );
  }
}