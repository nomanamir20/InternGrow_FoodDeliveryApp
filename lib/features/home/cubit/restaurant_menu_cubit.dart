import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/meal_api_service.dart';
import '../../product/models/meal_model.dart';

abstract class RestaurantMenuState extends Equatable {
  const RestaurantMenuState();

  @override
  List<Object?> get props => [];
}

class RestaurantMenuLoading extends RestaurantMenuState {
  const RestaurantMenuLoading();
}

class RestaurantMenuLoaded extends RestaurantMenuState {
  final List<Meal> meals;
  const RestaurantMenuLoaded(this.meals);

  @override
  List<Object?> get props => [meals];
}

class RestaurantMenuError extends RestaurantMenuState {
  final String message;
  const RestaurantMenuError(this.message);

  @override
  List<Object?> get props => [message];
}

class RestaurantMenuCubit extends Cubit<RestaurantMenuState> {
  final MealApiService _api;

  RestaurantMenuCubit(this._api) : super(const RestaurantMenuLoading());

  Future<void> loadMenu(String category) async {
    emit(const RestaurantMenuLoading());
    try {
      final meals = await _api.fetchMealsByCategory(category);
      emit(RestaurantMenuLoaded(meals));
    } catch (e) {
      emit(const RestaurantMenuError('Could not load menu. Pull down to try again.'));
    }
  }
}