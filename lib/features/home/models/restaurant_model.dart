/// A restaurant, modeled locally since TheMealDB has no restaurant concept.
/// Each restaurant is tied to a TheMealDB category — its "menu" is that
/// category's meals, fetched live from the API.
class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String mealDbCategory; // matches TheMealDB's strCategory exactly
  final String imageUrl;
  final double rating;
  final int deliveryTimeMinutes;
  final double deliveryFee;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.mealDbCategory,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTimeMinutes,
    required this.deliveryFee,
  });
}