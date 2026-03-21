// import 'package:flutter/material.dart';

// class AppColors {
//   static const Color purpleColor = Color(0xFF7B2CBF);
//   static const Color lightGreyColor = Color(0xFFE0E0E0);
//   static const Color greyColor = Color(0xFF7D7D7D);
//   static const Color blackColor = Color(0xFF000000);
//   static const Color redColor = Color(0xFFE73A3A);
//   static const Color whiteColor = Colors.white;
//   static const Color orangeColor = Colors.orange;
//   static final Color lightDisabledColor = Colors.grey[300]!;
//   static final Color darkDisabledColor = Colors.grey[600]!;

//   static const avatarColorList = [
//     Color(0xFF611E9C),
//     Color(0xFF8F45CB),
//     Color(0xFF5052C6),
//     Color(0xFF47ADC1),
//     Color(0xFF39B091),
//   ];

//   static Color avatarColor(String name) =>
//       avatarColorList[name.hashCode.abs() % avatarColorList.length];
// }
import 'package:flutter/material.dart';

class AppColors {
  static const Color purpleColor = Color(0xFF7B2CBF);
  static const Color lightGreyColor = Color(0xFFE0E0E0);
  static const Color greyColor = Color(0xFF7D7D7D);
  static const Color blackColor = Color(0xFF000000);
  static const Color redColor = Color(0xFFE73A3A);
  static const Color whiteColor = Colors.white;
  static const Color orangeColor = Colors.orange;

  // Dark Theme Specifics
  static const Color darkBgColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkInputColor = Color(0xFF2C2C2C);

  static final Color lightDisabledColor = Colors.grey[300]!;
  static final Color darkDisabledColor = Colors.grey[600]!;

  static const avatarColorList = [
    Color(0xFF611E9C),
    Color(0xFF8F45CB),
    Color(0xFF5052C6),
    Color(0xFF47ADC1),
    Color(0xFF39B091),
  ];

  static Color avatarColor(String name) =>
      avatarColorList[name.hashCode.abs() % avatarColorList.length];
}
