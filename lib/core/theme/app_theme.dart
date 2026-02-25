import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // 1. Defining the ColorScheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryPurple,
      primary: AppColors.primaryPurple,
      onPrimary: AppColors.white,
      surface: AppColors.white,
      error: AppColors.errorRed,
      onSurface: AppColors.textBlack,
    ),

    scaffoldBackgroundColor: AppColors.white,

    // 2. Text Theme
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.headingBold,
      displayMedium: AppTextStyles.subHeadingBold,
      bodyLarge: AppTextStyles.labelMedium,
      bodyMedium: AppTextStyles.bodyGrey,
      labelLarge: AppTextStyles.buttonText,
    ),

    // 3. Button Themes
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textGrey,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    // 4. Input Decoration Theme
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

    // 5. Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.secondaryGrey,
      thickness: 1,
    ),

    // 6. SnackBar Theme
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.primaryPurple,
      contentTextStyle: AppTextStyles.buttonText,
    ),

    // 7. BottomNavigationBar Theme
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
