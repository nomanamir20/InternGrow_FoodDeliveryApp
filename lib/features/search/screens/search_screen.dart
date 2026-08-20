import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/services/meal_api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/widgets/meal_card.dart';
import '../cubit/search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(MealApiService()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: subTextColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search for food...',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (value) => context.read<SearchCubit>().search(value),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, value, _) {
                  if (value.text.isEmpty) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () {
                      _controller.clear();
                      context.read<SearchCubit>().search('');
                    },
                    child: Icon(Icons.close, color: subTextColor, size: 18),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return Center(
              child: Text('Start typing to search for food', style: TextStyle(color: subTextColor)),
            );
          }
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchError) {
            return Center(
              child: Text('Something went wrong searching.', style: TextStyle(color: subTextColor)),
            );
          }

          final loaded = state as SearchLoaded;
          if (loaded.results.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off, size: 48, color: subTextColor),
                    const SizedBox(height: 12),
                    Text(
                      'No results found for "${loaded.query}"',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: subTextColor),
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: loaded.results.length,
            itemBuilder: (context, index) {
              final meal = loaded.results[index];
              return MealCard(
                meal: meal,
                onTap: () => context.push('${AppRoutes.productDetails}/${meal.id}'),
              );
            },
          );
        },
      ),
    );
  }
}