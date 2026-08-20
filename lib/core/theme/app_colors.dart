import 'package:flutter/material.dart';

/// Centralized color tokens — a single place to re-theme the whole app.
class AppColors {
  AppColors._();
  static const Color primary = Color(0xFFFF5A1F);   // Warm orange — food/appetite association
  static const Color primaryDark = Color(0xFFE64A0F);
  static const Color accent = Color(0xFF2F9E44);      // Green — "delivered", fresh, success
  static const Color success = Color(0xFF2F9E44);
  static const Color error = Color(0xFFE03131);
  static const Color warning = Color(0xFFF08C00);

  static const Color lightBackground = Color(0xFFFAFAFB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE5E7EB);

  static const Color darkBackground = Color(0xFF0F1115);
  static const Color darkSurface = Color(0xFF1A1D23);
  static const Color darkBorder = Color(0xFF2A2E37);

  static const Color textPrimaryLight = Color(0xFF1A1D23);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFF5F5F7);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  static const Color ratingStar = Color(0xFFFAB005);
  static const Color discountBadge = Color(0xFFE03131);
}