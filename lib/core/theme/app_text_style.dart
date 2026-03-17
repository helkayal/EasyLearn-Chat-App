import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle headingBold = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  static const TextStyle subHeadingBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  static const TextStyle bodyGrey = TextStyle(
    fontSize: 16,
    color: AppColors.textGrey,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textBlack,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle whiteText = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
}
