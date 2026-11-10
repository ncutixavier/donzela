import 'package:flutter/material.dart';

/// Design tokens sampled from the MVP mockups. Screens read colours, spacing
/// and radii only from here.
abstract final class AppColors {
  // Brand
  static const brown = Color(0xFF3D2722); // headers, dark cards, PIN pad
  static const terracotta = Color(0xFFB5523B); // primary actions, period
  static const gold = Color(0xFFD9A441); // ovulation, fertile accents
  static const sage = Color(0xFF4F6F5A); // logged fertile day, success
  static const sageSoft = Color(0xFFDDE8DF);
  static const blush = Color(0xFFF4C6BF); // predicted period
  static const blushSoft = Color(0xFFFBE7E3);
  static const cream = Color(0xFFFBF4EC); // app background
  static const sand = Color(0xFFE8D9CB); // borders, inactive ring
  static const sandDark = Color(0xFFCDBBAE); // toggle off
  static const goldSoft = Color(0xFFF6E7C4); // fertile chip background
  static const surface = Color(0xFFFFFFFF); // cards
  static const ink = Color(0xFF3D2722); // main text
  static const inkMuted = Color(0xFF6B5A52); // secondary text
  static const danger = Color(0xFFA8322A);
}

abstract final class AppSpace {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16; // side gutter on phones
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class AppRadius {
  static const double chip = 999;
  static const double card = 20;
  static const double control = 14;
}

abstract final class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.terracotta,
      brightness: Brightness.light,
      primary: AppColors.terracotta,
      onPrimary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.cream,
      canvasColor: AppColors.cream,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.terracotta,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.terracotta,
          minimumSize: const Size.fromHeight(54),
          side: const BorderSide(color: AppColors.terracotta, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.terracotta),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: const BorderSide(color: AppColors.sand),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: const BorderSide(color: AppColors.sand),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cream,
        indicatorColor: AppColors.blushSoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.terracotta : AppColors.inkMuted,
          );
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.terracotta
                : AppColors.sandDark),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          height: 1.2,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.ink, height: 1.4),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.inkMuted,
          height: 1.4,
        ),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }
}
