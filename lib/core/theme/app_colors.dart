import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF388E3C);
  static const Color primaryDark = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFFE8F5E9);
  static const Color backgroundWave = Color(0xFFBAC8EE);

  // Backgrounds
  static const Color backgroundScreen = Color(0xFFF8F9FA);
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundLightGrey = Color(0xFFF5F5F5);

  // Text
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textGrey = Color(0xFF828282);
  static const Color textLightGrey = Color(0xFFBDBDBD);
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;

  // Borders & Dividers
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color dividerGrey = Color(0xFFEEEEEE);

  // Icons
  static const Color iconGrey = Color(0xFF9E9E9E);
  static const Color iconLightGrey = Color(0xFFE0E0E0);

  // Status/Alerts
  static const Color errorRed = Color(0xFFE53935);
  static const Color successGreen = Color(0xFF4CAF50);

  // Button disabled
  static const Color buttonDisabled = Color(0xFFEEEEEE);
  static const Color buttonDisabledText = Color(0xFFBDBDBD);

  // Specific
  static const Color agendaHeader = Color(0xFF265A8E);
  static const Color agendaBackground = Color(0xFFFDF7E7);
  static const Color assistantBackground = Color(0xFFF0F4FD);
  static const Color assistantIconColor = Color(0xFF4F7396);
  static const Color assistantBorder = Color(0xFFE3EAFC);

  // Emergency
  static const Color emergencyDark1 = Color(0xFF1A1A2E);
  static const Color emergencyDark2 = Color(0xFF16213E);
  static const Color ambulanceBlue = Color(0xFF1565C0);
  static const Color ambulanceBlueDark = Color(0xFF0D47A1);
  static const Color arrivedGreen1 = Color(0xFF1B5E20);
  static const Color arrivedGreen2 = Color(0xFF2E7D32);

  // Transparent / Opacity
  static const Color transparent = Colors.transparent;
  static Color shadowColor = Colors.black.withValues(alpha: 0.05);
  static Color overlayWhite20 = Colors.white.withValues(alpha: 0.2);
  static Color overlayPrimary15 = primary.withValues(alpha: 0.15);

  // Chatbot specific / additions
  static const Color iconOrange = Colors.orange;
  static const Color iconBlue = Colors.blue;
  static const Color iconGreen = Colors.green;

  // Social Colors
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);

  static Color black10 = Colors.black.withValues(alpha: 0.1);
  static Color white85 = Colors.white.withValues(alpha: 0.85);
  static Color white50 = Colors.white.withValues(alpha: 0.5);
  static Color grey20 = Colors.grey.withValues(alpha: 0.2);
  static Color primary85 = primary.withValues(alpha: 0.85);
  static Color orange10 = Colors.orange.withValues(alpha: 0.1);
  static Color iconWhite30 = Colors.white30;

  // Warning
  static const Color warningOrange = Colors.orange;
  static Color warningLight = Colors.orange.withValues(alpha: 0.1);
}
