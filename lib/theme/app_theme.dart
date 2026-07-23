import 'package:flutter/material.dart';
import 'package:product_catalogue/theme/app_colors.dart';
import 'package:product_catalogue/theme/app_text_styles.dart';

class AppTheme {
  
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
      error: AppColors.error,
    ),

    scaffoldBackgroundColor: AppColors.lightBackground,

    cardTheme: const CardThemeData(color: AppColors.lightCard, elevation: 2),

    dividerColor: AppColors.lightBorder,

    iconTheme: const IconThemeData(color: AppColors.lightTextSecondary),

    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: AppColors.lightTextPrimary,
      displayColor: AppColors.lightTextPrimary
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
      centerTitle: false,
    ),
  );


  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      error: AppColors.error,
    ),

    scaffoldBackgroundColor: AppColors.darkBackground,

    cardTheme: const CardThemeData(color: AppColors.darkCard, elevation: 2),

    dividerColor: AppColors.darkBorder,

    iconTheme: const IconThemeData(color: AppColors.darkTextSecondary),

    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: AppColors.darkTextPrimary,
      displayColor: AppColors.darkTextPrimary
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: false,
    ),
  );
}
