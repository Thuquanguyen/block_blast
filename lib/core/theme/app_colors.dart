import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF6C63FF);
  static const primaryDark = Color(0xFF4B3FE0);
  static const background = Color(0xFFF5F5F7);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF8A8A8A);

  // Pastel palette — soft purple-to-blue backdrop, peach accent for CTAs.
  static const backgroundStart = Color(0xFFE9E4FF);
  static const backgroundEnd = Color(0xFFDCEBFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceTint = Color(0xFFF3F0FF);
  static const accent = Color(0xFFFF9F6B);
  static const accentDark = Color(0xFFFF7A3D);

  static const shadow = Color(0x1F3A2E7A);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundStart, backgroundEnd],
  );

  static const primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const accentButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark],
  );
}
