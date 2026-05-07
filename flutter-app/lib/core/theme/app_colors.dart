import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const bgPrimary = Color(0xFF0A0B0F);
  static const bgSecondary = Color(0xFF0F1117);
  static const bgTertiary = Color(0xFF13151D);
  static const bgCard = Color(0xFF141720);
  static const bgCardHover = Color(0xFF1A1D28);
  static const bgInput = Color(0xFF0F1117);

  // Brand
  static const brandGreen = Color(0xFF00FF88);
  static const brandGreenDim = Color(0xFF00CC6A);
  static const brandRed = Color(0xFFFF3366);
  static const brandRedDim = Color(0xFFCC2952);
  static const brandBlue = Color(0xFF3B82F6);
  static const brandPurple = Color(0xFF8B5CF6);
  static const brandCyan = Color(0xFF06B6D4);
  static const brandAmber = Color(0xFFF59E0B);
  static const brandPink = Color(0xFFEC4899);
  static const brandOrange = Color(0xFFF97316);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0x99FFFFFF); // 60%
  static const textMuted = Color(0x4DFFFFFF); // 30%
  static const textDisabled = Color(0x26FFFFFF); // 15%

  // Borders
  static const borderSubtle = Color(0x0FFFFFFF); // 6%
  static const borderDefault = Color(0x1AFFFFFF); // 10%
  static const borderBright = Color(0x40FFFFFF); // 25%
  static const borderGreen = Color(0x3D00FF88); // green 24%

  // Glows
  static const glowGreen = Color(0x2600FF88);
  static const glowPurple = Color(0x268B5CF6);
  static const glowBlue = Color(0x263B82F6);
  static const glowRed = Color(0x26FF3366);
  static const glowAmber = Color(0x26F59E0B);

  // Semantic
  static const success = brandGreen;
  static const error = brandRed;
  static const warning = brandAmber;
  static const info = brandBlue;

  // Gradients
  static const gradientGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandGreen, brandGreenDim],
  );

  static const gradientPurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
  );

  static const gradientCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x0AFFFFFF), Color(0x03FFFFFF)],
  );

  static const gradientHero = RadialGradient(
    center: Alignment(0, -0.4),
    radius: 1.2,
    colors: [Color(0x1E00FF88), Color(0x000A0B0F)],
  );
}
