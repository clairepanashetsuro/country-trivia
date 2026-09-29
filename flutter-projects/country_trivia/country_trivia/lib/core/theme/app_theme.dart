import 'package:flutter/material.dart';

/// Application theme configuration.
class AppTheme {
  AppTheme._();

  // Brand colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color correct = Color(0xFF43A047);
  static const Color wrong = Color(0xFFE53935);
  static const Color background = Color(0xFFF5F5F5);
  static const Color card = Color(0xFFFFFFFF);

  // Dark mode colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);

  /// Light theme
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          surface: card,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: card,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

  /// Dark theme
  ///
  /// `brightness` must be passed to [ColorScheme.fromSeed] as well, otherwise
  /// it defaults to light and ThemeData asserts the two disagree.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
          primary: primary,
          surface: darkSurface,
        ),
        scaffoldBackgroundColor: darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkSurface,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: darkSurface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}
