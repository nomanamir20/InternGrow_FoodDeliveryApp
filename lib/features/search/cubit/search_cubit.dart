import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/meal_api_service.dart';
import '../../product/models/meal_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<Meal> results;
  final String query;
  const SearchLoaded(this.results, this.query);

  @override
  List<Object?> get props => [results, query];
}

class SearchError extends SearchState {
  const SearchError();
}

class SearchCubit extends Cubit<SearchState> {
  final MealApiService _api;
  Timer? _debounce;

  SearchCubit(this._api) : super(const SearchInitial());

  void search(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    // Debounce: wait 400ms after the last keystroke before actually
    // calling the API, avoiding a request fired on every character typed.
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final results = await _api.searchMeals(query.trim());
        emit(SearchLoaded(results, query.trim()));
      } catch (e) {
        emit(const SearchError());
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}