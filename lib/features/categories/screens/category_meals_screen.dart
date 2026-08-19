import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/services/meal_api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/cubit/restaurant_menu_cubit.dart';
import '../../home/widgets/meal_card.dart';

class CategoryMealsScreen extends StatelessWidget {
  final String category;

  const CategoryMealsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RestaurantMenuCubit(MealApiService())..loadMenu(category),
      child: Scaffold(
        appBar: AppBar(title: Text(category)),
        body: BlocBuilder<RestaurantMenuCubit, RestaurantMenuState>(
          builder: (context, state) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

            if (state is RestaurantMenuLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RestaurantMenuError) {
              return Center(child: Text(state.message, style: TextStyle(color: subTextColor)));
            }

            final meals = (state as RestaurantMenuLoaded).meals;
            if (meals.isEmpty) {
              return Center(child: Text('No items found in this category.', style: TextStyle(color: subTextColor)));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return MealCard(
                  meal: meal,
                  onTap: () => context.push('${AppRoutes.productDetails}/${meal.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}