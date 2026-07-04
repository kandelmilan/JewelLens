import 'package:flutter/material.dart';

/// Centralized color palette for the app.
/// Import this wherever a widget needs these colors instead of
/// redeclaring them locally.
class AppColors {
  AppColors._(); // prevent instantiation

  static const Color primary = Color(0xFF9C7C38);
  static const Color primaryLight = Color(0xFFF3ECDC);

  static const Color surface = Color(0xFFFAF7F2);

  static const Color textDark = Color(0xFF1F1B16);
  static const Color textMuted = Color(0xFF7A7168);
  static const Color textLight = Color(0xFF7A7168);

  static const Color border = Color(0xFFE4DED2);
  static const Color borderLight = Color(0xFFE4DED2);

  static const Color background = Color(0xFFFAF7F2);

  static const Color success = Color(0xFF3C9A5F);
}
