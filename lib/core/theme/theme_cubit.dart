import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages dark mode using flutter_bloc's Cubit — a simplified Bloc that
/// exposes direct methods instead of requiring event classes, while still
/// being part of the Bloc library ecosystem.
class ThemeCubit extends Cubit<ThemeMode> {
  static const _prefsKey = 'is_dark_mode';

  ThemeCubit() : super(ThemeMode.system) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getBool(_prefsKey);
    if (storedValue != null) {
      emit(storedValue ? ThemeMode.dark : ThemeMode.light);
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, isDark);
  }
}