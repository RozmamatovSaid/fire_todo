import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

abstract class CustomTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
    ),
    // Dialog theme
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
    ),
    // Bottom sheet theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.purple,
      surface: AppColors.background,
      onPrimary: AppColors.white,
      onSurface: AppColors.white,
    ),
    // Text theme
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.white),
      bodySmall: TextStyle(color: AppColors.white),
    ),
    // Card theme
    cardTheme: const CardThemeData(
      color: AppColors.darkGrey,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
