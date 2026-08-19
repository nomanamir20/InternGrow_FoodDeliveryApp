import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../models/mock_restaurants.dart';
import '../widgets/restaurant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('InternGrow Eats'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Restaurant list is static mock data — nothing to actually
          // refetch, but keeping the gesture for consistent UX.
          await Future.delayed(const Duration(milliseconds: 400));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: () => context.push(AppRoutes.search),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: subTextColor),
                    const SizedBox(width: 10),
                    Text('Search for food or restaurants...', style: TextStyle(color: subTextColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Restaurants near you',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            for (final restaurant in mockRestaurants)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RestaurantCard(
                  restaurant: restaurant,
                  onTap: () => context.push('${AppRoutes.home}/${restaurant.id}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}