import 'package:dio/dio.dart';

import '../../features/product/models/meal_model.dart';

/// Wraps all TheMealDB REST API calls.
/// https://www.themealdb.com/api.php
class MealApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.themealdb.com/api/json/v1/1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await _dio.get('/filter.php', queryParameters: {'c': category});
    final List<dynamic>? meals = response.data['meals'];
    if (meals == null) return [];
    return meals.map((json) => Meal.fromListJson(json as Map<String, dynamic>)).toList();
  }

  Future<Meal?> fetchMealById(String id) async {
    final response = await _dio.get('/lookup.php', queryParameters: {'i': id});
    final List<dynamic>? meals = response.data['meals'];
    if (meals == null || meals.isEmpty) return null;
    return Meal.fromDetailJson(meals.first as Map<String, dynamic>);
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await _dio.get('/search.php', queryParameters: {'s': query});
    final List<dynamic>? meals = response.data['meals'];
    if (meals == null) return [];
    return meals.map((json) => Meal.fromDetailJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<String>> fetchCategoryNames() async {
    final response = await _dio.get('/list.php', queryParameters: {'c': 'list'});
    final List<dynamic>? categories = response.data['meals'];
    if (categories == null) return [];
    return categories.map((c) => c['strCategory'] as String).toList();
  }
}