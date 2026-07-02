import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // =========================
  // Brand - New Vibrant Palette
  // =========================
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFF06B6D4); // Cyan

  // =========================
  // Status
  // =========================
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0xFFF43F5E); // Rose
  static const Color info = Color(0xFF3B82F6); // Blue

  // =========================
  // Page Gradients
  // =========================
  static const Color dashboardGradientStart = Color(0xFF4F46E5);
  static const Color dashboardGradientEnd = Color(0xFF7C3AED);

  static const Color budgetGradientStart = Color(0xFF059669);
  static const Color budgetGradientEnd = Color(0xFF10B981);

  static const Color paybackGradientStart = Color(0xFFF59E0B);
  static const Color paybackGradientEnd = Color(0xFFD97706);

  static const Color analyticsGradientStart = Color(0xFF0891B2);
  static const Color analyticsGradientEnd = Color(0xFF06B6D4);

  // =========================
  // Charts & Categories
  // =========================
  static const Color food = Color(0xFFF43F5E); // Rose
  static const Color transport = Color(0xFFF59E0B); // Amber
  static const Color shopping = Color(0xFF8B5CF6); // Violet
  static const Color bills = Color(0xFF10B981); // Emerald
  static const Color health = Color(0xFFEC4899); // Pink
  static const Color travel = Color(0xFF06B6D4); // Cyan
  static const Color entertainment = Color(0xFFF97316); // Orange
  static const Color education = Color(0xFF6366F1); // Indigo
  static const Color other = Color(0xFF64748B); // Slate

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
    secondaryContainer: Color(0xFFE0F2FE),
    onSecondaryContainer: Color(0xFF0369A1),
    primaryContainer: Color(0xFFEEF2FF),
    onPrimaryContainer: Color(0xFF4338CA),
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
    secondaryContainer: Color(0xFF0C4A6E),
    onSecondaryContainer: Color(0xFF7DD3FC),
    primaryContainer: Color(0xFF312E81),
    onPrimaryContainer: Color(0xFFC7D2FE),
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
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.brightness == Brightness.dark
            ? colorScheme.surface.withAlpha(50)
            : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.w500,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colorScheme.primary,
              size: 28,
            );
          }
          return IconThemeData(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final style = TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            letterSpacing: 0.2,
          );
          if (states.contains(WidgetState.selected)) {
            return style.copyWith(color: colorScheme.primary);
          }
          return style.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          );
        }),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        modalBackgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        showDragHandle: true,
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.onSurface.withValues(alpha: 0.08),
        thickness: 1,
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
        ),
        headlineMedium: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
          letterSpacing: 0.1,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 14,
        ),
      ),
    );
  }
}
