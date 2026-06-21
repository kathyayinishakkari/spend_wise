import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF4F46E5);
  static const _success = Color(0xFF10B981);
  static const _accent = Color(0xFFF59E0B);

  static ThemeData light() => _theme(Brightness.light);
  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: brightness,
    );
    return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,

    scaffoldBackgroundColor:
    brightness == Brightness.light
    ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A),

    appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    foregroundColor: scheme.onSurface,
    ),

    cardTheme: CardThemeData(
    elevation: 0,
    color: scheme.surface,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
    ),
    ),

    filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
    padding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 16,
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
    ),
    ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _primary,
    foregroundColor: Colors.white,
    elevation: 10,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    ),
    ),

    inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor:
    brightness == Brightness.light
    ? Colors.white
        : scheme.surfaceContainerHighest,

    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide.none,
    ),

    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide(
    color: _primary,
    width: 1.5,
    ),
    ),
    ),

    navigationBarTheme: NavigationBarThemeData(
    height: 72,
    backgroundColor: scheme.surface,
    indicatorColor: _primary.withOpacity(.15),
    labelTextStyle: WidgetStatePropertyAll(
    TextStyle(
    color: scheme.onSurface,
    fontWeight: FontWeight.w600,
    ),
    ),
    ),

    snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    ),
    ),
    );

  }
}
