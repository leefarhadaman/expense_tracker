// core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color accentColor = Color(0xFF50C878);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  static final MaterialColor primarySwatch = MaterialColor(
    primaryColor.value,
    {
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor,
    },
  );
}