import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  // --- LIGHT THEME ---
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.purpleColor,
      primary: AppColors.purpleColor,
      onPrimary: AppColors.whiteColor,
      secondary: AppColors.greyColor,
      onSecondary: AppColors.lightGreyColor,
      surface: AppColors.orangeColor,
      onSurface: AppColors.blackColor,
      tertiary: AppColors.lightDisabledColor,
      onTertiary: AppColors.darkDisabledColor,
      error: AppColors.redColor,
    ),

    scaffoldBackgroundColor: AppColors.whiteColor,

    textTheme: const TextTheme(
      displayLarge: AppTextStyles.black28Bold,
      displayMedium: AppTextStyles.black24Bold,
      bodyLarge: AppTextStyles.black16Medium,
      bodyMedium: AppTextStyles.grey16Normal,
      labelLarge: AppTextStyles.text18SemiBold,
      labelMedium: AppTextStyles.whiteBold,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightGreyColor,
      foregroundColor: AppColors.blackColor,
    ),

    inputDecorationTheme: _inputDecoration(isDark: false),

    dividerTheme: const DividerThemeData(
      color: AppColors.lightGreyColor,
      thickness: 1,
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.purpleColor,
      contentTextStyle: AppTextStyles.text18SemiBold,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.whiteColor,
      selectedItemColor: AppColors.purpleColor,
      unselectedItemColor: AppColors.greyColor,
      showSelectedLabels: true,
      selectedIconTheme: IconThemeData(size: 30),
      unselectedIconTheme: IconThemeData(size: 25),
    ),
  );

  // --- DARK THEME ---
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.purpleColor,
      brightness: Brightness.dark,
      primary: AppColors.purpleColor,
      onPrimary: AppColors.whiteColor,
      secondary: AppColors.greyColor,
      onSecondary: AppColors.darkDisabledColor,
      surface: AppColors.orangeColor,
      onSurface: AppColors.blackColor,
      tertiary: AppColors.darkSurfaceColor,
      onTertiary: AppColors.lightDisabledColor,
      error: AppColors.redColor,
    ),

    scaffoldBackgroundColor: AppColors.darkBgColor,

    textTheme: const TextTheme(
      displayLarge: AppTextStyles.white28Bold,
      displayMedium: AppTextStyles.white24Bold,
      bodyLarge: AppTextStyles.white16Medium,
      bodyMedium: AppTextStyles.grey16Normal,
      labelLarge: AppTextStyles.text18SemiBold,
      labelMedium: AppTextStyles.whiteBold,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurfaceColor,
      foregroundColor: AppColors.whiteColor,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.darkSurfaceColor,
      thickness: 1,
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.purpleColor,
      contentTextStyle: AppTextStyles.text18SemiBold,
    ),

    inputDecorationTheme: _inputDecoration(isDark: true),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurfaceColor,
      selectedItemColor: AppColors.purpleColor,
      unselectedItemColor: AppColors.greyColor,
    ),
  );

  // Helper to keep code clean since borders are similar
  static InputDecorationTheme _inputDecoration({required bool isDark}) {
    return InputDecorationTheme(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: isDark
              ? AppColors.darkDisabledColor
              : AppColors.lightGreyColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: isDark
              ? AppColors.darkDisabledColor
              : AppColors.lightGreyColor,
        ),
      ),
    );
  }
}
