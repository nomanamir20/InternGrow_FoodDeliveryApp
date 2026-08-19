import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({super.key, required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: restaurant.imageUrl,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 96,
                  height: 96,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                errorWidget: (context, url, error) => Container(
                  width: 96,
                  height: 96,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  child: const Icon(Icons.restaurant),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      restaurant.cuisine,
                      style: TextStyle(color: subTextColor, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.ratingStar, size: 15),
                        const SizedBox(width: 3),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time, size: 14, color: subTextColor),
                        const SizedBox(width: 3),
                        Text(
                          '${restaurant.deliveryTimeMinutes} min',
                          style: TextStyle(color: subTextColor, fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.delivery_dining, size: 14, color: subTextColor),
                        const SizedBox(width: 3),
                        Text(
                          '\$${restaurant.deliveryFee.toStringAsFixed(2)}',
                          style: TextStyle(color: subTextColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}