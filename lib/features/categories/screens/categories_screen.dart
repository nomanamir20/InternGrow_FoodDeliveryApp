import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/services/meal_api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/categories_cubit.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoriesCubit(MealApiService())..loadCategories(),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatelessWidget {
  const _CategoriesView();

  // Small curated set of icons/colors per known TheMealDB category, with a
  // sensible fallback for any category not explicitly listed.
  static const Map<String, IconData> _categoryIcons = {
    'Beef': Icons.lunch_dining,
    'Chicken': Icons.set_meal,
    'Dessert': Icons.icecream,
    'Lamb': Icons.dinner_dining,
    'Miscellaneous': Icons.restaurant,
    'Pasta': Icons.ramen_dining,
    'Pork': Icons.kebab_dining,
    'Seafood': Icons.set_meal_outlined,
    'Side': Icons.tapas,
    'Starter': Icons.soup_kitchen,
    'Vegan': Icons.eco,
    'Vegetarian': Icons.grass,
    'Breakfast': Icons.free_breakfast,
    'Goat': Icons.dinner_dining,
  };

  IconData _iconFor(String category) => _categoryIcons[category] ?? Icons.restaurant_menu;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(title: const Text('Food Categories')),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoriesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center, style: TextStyle(color: subTextColor)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CategoriesCubit>().loadCategories(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final categories = (state as CategoriesLoaded).categories;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => context.push('${AppRoutes.categories}/$category'),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(_iconFor(category), color: AppColors.primary),
                      ),
                      const Spacer(),
                      Text(
                        category,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}