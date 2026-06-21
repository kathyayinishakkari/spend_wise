import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF0F172A);
  static const Color primaryDark = Color(0xFF1D4ED8);

  static const Color secondary = Color(0xFFF59E0B);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color darkBackground = Color(0xFF0F172A);

  static const Color cardBackground = Color(0xFFFFFFFF);

  static const Color darkText = Color(0xFF0F172A);
  static const Color mutedText = Color(0xFF64748B);

  static ThemeData light() => _theme(Brightness.light);

  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme(
    brightness: brightness,
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: isDark
    ? const Color(0xFF1E293B)
        : Colors.white,
    onSurface: isDark
    ? Colors.white
        : const Color(0xFF0F172A),
    );

    return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,

    scaffoldBackgroundColor:
    isDark ? darkBackground : lightBackground,

    appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    surfaceTintColor: Colors.transparent,
    foregroundColor: colorScheme.onSurface,
    titleTextStyle: TextStyle(
    color: colorScheme.onSurface,
    fontWeight: FontWeight.w700,
    fontSize: 22,
    ),
    ),

    cardTheme: CardThemeData(
    elevation: 0,
    color: colorScheme.surface,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
    ),
    ),

    filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 16,
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
    ),
    ),
    ),

    floatingActionButtonTheme:
    const FloatingActionButtonThemeData(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    elevation: 10,
    ),

    inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: isDark
    ? const Color(0xFF1E293B)
        : Colors.white,

    contentPadding:
    const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
    ),

    border: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(18),
    borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(18),
    borderSide: BorderSide.none,
    ),

    focusedBorder: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(18),
    borderSide: const BorderSide(
    color: primary,
    width: 1.5,
    ),
    ),
    ),

    navigationBarTheme:
    NavigationBarThemeData(
    height: 72,
    backgroundColor:
    isDark
    ? const Color(0xFF1E293B)
        : Colors.white,

      indicatorColor: primary,

    labelTextStyle:
    WidgetStatePropertyAll(
    TextStyle(
    color: colorScheme.onSurface,
    fontWeight: FontWeight.w600,
    ),
    ),
    ),

    dividerTheme: DividerThemeData(
    color: isDark
    ? Colors.white10
        : Colors.black12,
    ),

    snackBarTheme: SnackBarThemeData(
    behavior:
    SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
    borderRadius:
    BorderRadius.circular(16),
    ),
    ),
    );
  }
}
