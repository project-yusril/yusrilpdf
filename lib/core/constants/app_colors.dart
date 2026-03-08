import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFFE53E3E);
  static const Color primaryDark = Color(0xFFC53030);
  static const Color primaryLight = Color(0xFFFEB2B2);

  // Background
  static const Color bgDark = Color(0xFF0F0F0F);
  static const Color bgDarkSecondary = Color(0xFF1A1A1A);
  static const Color bgDarkCard = Color(0xFF242424);
  static const Color bgDarkSurface = Color(0xFF2D2D2D);

  // Light mode
  static const Color bgLight = Color(0xFFF7F7F8);
  static const Color bgLightCard = Color(0xFFFFFFFF);
  static const Color bgLightSurface = Color(0xFFF0F0F0);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFBEBEBE);
  static const Color textHint = Color(0xFF717171);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textDarkSecondary = Color(0xFF4A4A4A);

  // Category Colors
  static const Color catOptimize = Color(0xFFE53E3E); // Red
  static const Color catConvertTo = Color(0xFF3182CE); // Blue
  static const Color catConvertFrom = Color(0xFF38A169); // Green
  static const Color catEdit = Color(0xFFD69E2E); // Yellow
  static const Color catAdvanced = Color(0xFF805AD5); // Purple

  // Status
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFFC8181);
  static const Color info = Color(0xFF63B3ED);

  // Misc
  static const Color divider = Color(0xFF2D2D2D);
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color overlay = Color(0x80000000);
  static const Color shimmerBase = Color(0xFF2D2D2D);
  static const Color shimmerHighlight = Color(0xFF3D3D3D);

  // Gradient
  static const List<Color> primaryGradient = [
    Color(0xFFE53E3E),
    Color(0xFFFF6B6B),
  ];
  static const List<Color> darkGradient = [
    Color(0xFF1A1A1A),
    Color(0xFF0F0F0F),
  ];
}
