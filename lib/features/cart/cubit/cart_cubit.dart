import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../product/models/meal_model.dart';
import '../models/cart_item_model.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState(this.items);

  double get total => items.fold(0.0, (sum, item) => sum + item.lineTotal);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool isInCart(String mealId) => items.any((item) => item.meal.id == mealId);

  @override
  List<Object?> get props => [items];
}

class CartCubit extends Cubit<CartState> {
  static const _prefsKey = 'cart_items';

  CartCubit() : super(const CartState([])) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    if (stored != null) {
      final List<dynamic> decoded = jsonDecode(stored);
      final items = decoded.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList();
      emit(CartState(items));
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(state.items.map((item) => item.toJson()).toList());
    await prefs.setString(_prefsKey, encoded);
  }

  void addToCart(Meal meal, {int quantity = 1}) {
    final existingIndex = state.items.indexWhere((item) => item.meal.id == meal.id);

    List<CartItem> updated;
    if (existingIndex >= 0) {
      final existing = state.items[existingIndex];
      updated = [
        for (int i = 0; i < state.items.length; i++)
          if (i == existingIndex)
            existing.copyWith(quantity: existing.quantity + quantity)
          else
            state.items[i],
      ];
    } else {
      updated = [...state.items, CartItem(meal: meal, quantity: quantity)];
    }

    emit(CartState(updated));
    _saveToPrefs();
  }

  void updateQuantity(String mealId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(mealId);
      return;
    }
    final updated = [
      for (final item in state.items)
        if (item.meal.id == mealId) item.copyWith(quantity: quantity) else item,
    ];
    emit(CartState(updated));
    _saveToPrefs();
  }

  void removeFromCart(String mealId) {
    final updated = state.items.where((item) => item.meal.id != mealId).toList();
    emit(CartState(updated));
    _saveToPrefs();
  }

  void clearCart() {
    emit(const CartState([]));
    _saveToPrefs();
  }
}