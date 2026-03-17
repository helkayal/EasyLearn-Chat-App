import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryPurple,
      primary: AppColors.primaryPurple,
      onPrimary: AppColors.white,
      secondary: AppColors.textGrey,
      onSecondary: AppColors.secondaryGrey,
      surface: AppColors.orange,
      onSurface: AppColors.textBlack,
      tertiary: AppColors.disabledButton,
      onTertiary: AppColors.disabledText,
      error: AppColors.errorRed,
    ),

    scaffoldBackgroundColor: AppColors.white,

    textTheme: const TextTheme(
      displayLarge: AppTextStyles.headingBold,
      displayMedium: AppTextStyles.subHeadingBold,
      bodyLarge: AppTextStyles.labelMedium,
      bodyMedium: AppTextStyles.bodyGrey,
      labelLarge: AppTextStyles.buttonText,
      labelMedium: AppTextStyles.whiteText,
    ),

    appBarTheme: AppBarTheme(backgroundColor: AppColors.secondaryGrey),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textGrey,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.textGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.secondaryGrey),
      ),
      // Error styling for TextFields
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.errorRed),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.secondaryGrey,
      thickness: 1,
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.primaryPurple,
      contentTextStyle: AppTextStyles.buttonText,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryPurple,
      unselectedItemColor: AppColors.textGrey,
      showSelectedLabels: true,
      selectedIconTheme: IconThemeData(size: 30),
      unselectedIconTheme: IconThemeData(size: 25),
    ),
  );
}
