import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cart/models/cart_item_model.dart';
import '../models/order_model.dart';

class OrdersState extends Equatable {
  final List<FoodOrder> orders;

  const OrdersState(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrdersCubit extends Cubit<OrdersState> {
  static const _prefsKey = 'food_order_history';
  final Map<String, Timer> _activeTimers = {};

  OrdersCubit() : super(const OrdersState([])) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    if (stored != null) {
      final List<dynamic> decoded = jsonDecode(stored);
      final orders = decoded.map((e) => FoodOrder.fromJson(e as Map<String, dynamic>)).toList();
      emit(OrdersState(orders));

      // Resume live progression for any order that hadn't finished
      // delivering yet when the app was last closed.
      for (final order in orders) {
        if (order.status != OrderStatus.delivered) {
          _scheduleNextStage(order.id, order.status);
        }
      }
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(state.orders.map((o) => o.toJson()).toList());
    await prefs.setString(_prefsKey, encoded);
  }

  FoodOrder? findById(String id) {
    try {
      return state.orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  void createOrder({
    required String id,
    required List<CartItem> items,
    required double total,
    required String deliveryAddress,
    required double deliveryLatitude,
    required double deliveryLongitude,
    String? couponCode,
    double discountAmount = 0,
  }) {
    final order = FoodOrder(
      id: id,
      items: items,
      total: total,
      deliveryAddress: deliveryAddress,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      orderDate: DateTime.now(),
      status: OrderStatus.placed,
      couponCode: couponCode,
      discountAmount: discountAmount,
    );

    emit(OrdersState([order, ...state.orders]));
    _saveToPrefs();
    _scheduleNextStage(id, OrderStatus.placed);
  }

  void _scheduleNextStage(String orderId, OrderStatus currentStatus) {
    _activeTimers[orderId]?.cancel();

    if (currentStatus == OrderStatus.delivered) return;

    // Each stage advances after a short delay — fast enough to demo live
    // in an interview, slow enough to feel like a real progression.
    _activeTimers[orderId] = Timer(const Duration(seconds: 8), () {
      final order = findById(orderId);
      if (order == null) return;

      final nextStatus = OrderStatus.values[order.status.index + 1];
      final updated = order.copyWith(status: nextStatus);

      final updatedOrders = [
        for (final o in state.orders) if (o.id == orderId) updated else o,
      ];
      emit(OrdersState(updatedOrders));
      _saveToPrefs();

      _scheduleNextStage(orderId, nextStatus);
    });
  }

  @override
  Future<void> close() {
    for (final timer in _activeTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}