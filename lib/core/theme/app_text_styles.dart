import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle h1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 13,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    color: AppColors.textMuted,
  );

  static const TextStyle small = TextStyle(
    fontSize: 10,
    color: AppColors.textMuted,
  );

  static const TextStyle productName = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle price = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle priceLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  static const TextStyle priceStrike = TextStyle(
    fontSize: 10,
    color: AppColors.textMuted,
    decoration: TextDecoration.lineThrough,
  );
}
