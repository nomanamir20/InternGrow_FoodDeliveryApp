import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/services/meal_api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/restaurant_menu_cubit.dart';
import '../models/restaurant_model.dart';
import '../widgets/meal_card.dart';

class RestaurantMenuScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantMenuScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RestaurantMenuCubit(MealApiService())..loadMenu(restaurant.mealDbCategory),
      child: _RestaurantMenuView(restaurant: restaurant),
    );
  }
}

class _RestaurantMenuView extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantMenuView({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(restaurant.name),
              background: Image.network(
                restaurant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(color: AppColors.primary),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.star, color: AppColors.ratingStar, size: 18),
                  const SizedBox(width: 4),
                  Text(restaurant.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: subTextColor),
                  const SizedBox(width: 4),
                  Text('${restaurant.deliveryTimeMinutes} min', style: TextStyle(color: subTextColor)),
                  const SizedBox(width: 16),
                  Icon(Icons.delivery_dining, size: 16, color: subTextColor),
                  const SizedBox(width: 4),
                  Text('\$${restaurant.deliveryFee.toStringAsFixed(2)} delivery', style: TextStyle(color: subTextColor)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: BlocBuilder<RestaurantMenuCubit, RestaurantMenuState>(
              builder: (context, state) {
                if (state is RestaurantMenuLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is RestaurantMenuError) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.message, style: TextStyle(color: subTextColor))),
                  );
                }
                final meals = (state as RestaurantMenuLoaded).meals;
                if (meals.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(child: Text('No menu items available.', style: TextStyle(color: subTextColor))),
                  );
                }
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final meal = meals[index];
                      return MealCard(
                        meal: meal,
                        onTap: () => context.push('${AppRoutes.productDetails}/${meal.id}'),
                      );
                    },
                    childCount: meals.length,
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}