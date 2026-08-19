/// A menu item from TheMealDB, adapted to represent a food item on a
/// restaurant's menu.
class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String area;
  final String instructions;
  final List<String> ingredients;
  final List<String> measures;

  const Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.category,
    required this.area,
    required this.instructions,
    required this.ingredients,
    required this.measures,
  });

  /// TheMealDB has no price data (it's a recipe API) — we derive a
  /// consistent, deterministic mock price from the meal ID so the same
  /// meal always shows the same price rather than a random one each load.
  double get price {
    final idNum = int.tryParse(id) ?? id.hashCode;
    return 5.99 + (idNum % 15);
  }

  /// Basic listing-only constructor (from filter.php, which returns
  /// limited fields — no instructions/ingredients).
  factory Meal.fromListJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String? ?? '',
      thumbnail: json['strMealThumb'] as String? ?? '',
      category: '',
      area: '',
      instructions: '',
      ingredients: const [],
      measures: const [],
    );
  }

  /// Full detail constructor (from lookup.php).
  factory Meal.fromDetailJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    final measures = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(ingredient.trim());
        measures.add((measure ?? '').trim());
      }
    }

    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String? ?? '',
      thumbnail: json['strMealThumb'] as String? ?? '',
      category: json['strCategory'] as String? ?? '',
      area: json['strArea'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }
}