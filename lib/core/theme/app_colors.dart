import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette (teal)
  static const Color primary = Color(0xFF1F6F5F);
  static const Color primaryDark = Color(0xFF185A4D);
  static const Color secondary = Color(0xFF2FA084);
  static const Color tertiary = Color(0xFF6FCF97);
  static const Color accent = Color(0xFF6FCF97);

  // Surfaces & neutrals
  static const Color background = Color(0xFFF7F8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF616161);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color slate50 = Color(0xFFF8FAFC);

  // Text
  static const Color textPrimary = Color(0xFF1F2A2E);
  static const Color textMuted = Color(0xFF8C9A97);

  // Soft tints
  static const Color accentSoft = Color(0xFFE6F4EC);
  static const Color primarySoft = Color(0xFFE0EEEA);
  static const Color borderSoft = Color(0xFFEEF1F0);
  static const Color star = Color(0xFFFFB400);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Order status
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusPaid = Color(0xFF3B82F6);
  static const Color statusShipping = Color(0xFF6366F1);
  static const Color statusDelivered = Color(0xFF22C55E);
  static const Color statusExpired = Color(0xFFF97316);
  static const Color statusCancelled = Color(0xFFEF4444);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1F6F5F), Color(0xFF2FA084)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
