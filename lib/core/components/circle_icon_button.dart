import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 28,
    this.iconSize = 14,
    this.borderColor = const Color(0xFFDEDFE4),
    this.iconColor = AppColors.textPrimary,
    this.background,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color borderColor;
  final Color iconColor;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: background == null ? Border.all(color: borderColor) : null,
        ),
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
