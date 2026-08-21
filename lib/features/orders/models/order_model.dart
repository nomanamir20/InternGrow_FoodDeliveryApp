import '../../cart/models/cart_item_model.dart';

enum OrderStatus { placed, preparing, outForDelivery, delivered }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Preparing Your Food';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.placed:
        return 'Your order has been received.';
      case OrderStatus.preparing:
        return 'The restaurant is preparing your food.';
      case OrderStatus.outForDelivery:
        return 'Your rider is on the way.';
      case OrderStatus.delivered:
        return 'Enjoy your meal!';
    }
  }
}

class FoodOrder {
  final String id;
  final List<CartItem> items;
  final double total;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final DateTime orderDate;
  final OrderStatus status;
  final String? couponCode;
  final double discountAmount;

  const FoodOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.orderDate,
    required this.status,
    this.couponCode,
    this.discountAmount = 0,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  FoodOrder copyWith({OrderStatus? status}) {
    return FoodOrder(
      id: id,
      items: items,
      total: total,
      deliveryAddress: deliveryAddress,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      orderDate: orderDate,
      status: status ?? this.status,
      couponCode: couponCode,
      discountAmount: discountAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((i) => i.toJson()).toList(),
      'total': total,
      'deliveryAddress': deliveryAddress,
      'deliveryLatitude': deliveryLatitude,
      'deliveryLongitude': deliveryLongitude,
      'orderDate': orderDate.toIso8601String(),
      'status': status.index,
      'couponCode': couponCode,
      'discountAmount': discountAmount,
    };
  }

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'] as String,
      deliveryLatitude: (json['deliveryLatitude'] as num).toDouble(),
      deliveryLongitude: (json['deliveryLongitude'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: OrderStatus.values[json['status'] as int],
      couponCode: json['couponCode'] as String?,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
    );
  }
}