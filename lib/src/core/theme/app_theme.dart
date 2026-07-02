import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // =========================
  // Brand
  // =========================
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF10B981);

  // =========================
  // Status
  // =========================
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // =========================
  // Page Gradients
  // =========================
  static const Color dashboardGradientStart = Color(0xFF2563EB);
  static const Color dashboardGradientEnd = Color(0xFF1D4ED8);

  static const Color budgetGradientStart = Color(0xFF10B981);
  static const Color budgetGradientEnd = Color(0xFF059669);

  static const Color paybackGradientStart = Color(0xFFF59E0B);
  static const Color paybackGradientEnd = Color(0xFFD97706);

  static const Color analyticsGradientStart = Color(0xFF06B6D4);
  static const Color analyticsGradientEnd = Color(0xFF0891B2);

  // =========================
  // Charts
  // =========================
  static const Color food = Color(0xFF06B6D4);
  static const Color transport = Color(0xFF3B82F6);
  static const Color shopping = Color(0xFF8B5CF6);
  static const Color bills = Color(0xFFF97316);
  static const Color health = Color(0xFF22C55E);
  static const Color travel = Color(0xFF14B8A6);
  static const Color entertainment = Color(0xFFEC4899);
  static const Color education = Color(0xFF6366F1);
  static const Color other = Color(0xFF94A3B8);

  static ThemeData light() => _theme(_lightScheme);

  static ThemeData dark() => _theme(_darkScheme);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    error: danger,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF0F172A),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    error: danger,
    onError: Colors.white,
    surface: Color(0xFF1E293B),
    onSurface: Color(0xFFF8FAFC),
  );

  static ThemeData _theme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: colorScheme.brightness == Brightness.dark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
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
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 8,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.onSurface.withValues(alpha: 0.12),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.onSurface.withValues(alpha: 0.12),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surface,
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.8),
        ),
        labelLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}