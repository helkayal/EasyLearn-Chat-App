import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF7B2CBF);
  static const Color secondaryGrey = Color(0xFFE0E0E0);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color textBlack = Color(0xFF000000);
  static const Color errorRed = Color(0xFFE73A3A);
  static const Color white = Colors.white;
  static final Color disabledButton = Colors.grey[300]!;
  static final Color disabledText = Colors.grey[600]!;

  static const _palette = [
    Color(0xFF611E9C),
    Color(0xFF8F45CB),
    Color(0xFF5052C6),
    Color(0xFF47ADC1),
    Color(0xFF39B091),
  ];

  static Color avatarColor(String name) =>
      _palette[name.hashCode.abs() % _palette.length];
}
