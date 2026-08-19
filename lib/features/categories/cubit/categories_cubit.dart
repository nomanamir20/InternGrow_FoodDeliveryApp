import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/meal_api_service.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  final List<String> categories;
  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesError extends CategoriesState {
  final String message;
  const CategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoriesCubit extends Cubit<CategoriesState> {
  final MealApiService _api;

  CategoriesCubit(this._api) : super(const CategoriesLoading());

  Future<void> loadCategories() async {
    emit(const CategoriesLoading());
    try {
      final categories = await _api.fetchCategoryNames();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(const CategoriesError('Could not load categories. Please try again.'));
    }
  }
}