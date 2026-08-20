import '../../product/models/meal_model.dart';

/// A meal plus a quantity — one line item in the cart.
class CartItem {
  final Meal meal;
  final int quantity;

  const CartItem({required this.meal, required this.quantity});

  double get lineTotal => meal.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      meal: meal,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal': {
        'id': meal.id,
        'name': meal.name,
        'thumbnail': meal.thumbnail,
        'category': meal.category,
        'area': meal.area,
        'instructions': meal.instructions,
        'ingredients': meal.ingredients,
        'measures': meal.measures,
      },
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final mealJson = json['meal'] as Map<String, dynamic>;
    return CartItem(
      meal: Meal(
        id: mealJson['id'] as String,
        name: mealJson['name'] as String,
        thumbnail: mealJson['thumbnail'] as String,
        category: mealJson['category'] as String,
        area: mealJson['area'] as String,
        instructions: mealJson['instructions'] as String,
        ingredients: List<String>.from(mealJson['ingredients'] as List),
        measures: List<String>.from(mealJson['measures'] as List),
      ),
      quantity: json['quantity'] as int,
    );
  }
}