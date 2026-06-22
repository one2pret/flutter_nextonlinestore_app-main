import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool _isFilled;
  final double? width;
  final double height;
  final double fontSize;
  final Color? color;
  final bool disabled;

  const Button.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.width,
    this.height = 48,
    this.fontSize = 16,
    this.color,
    this.disabled = false,
  }) : _isFilled = true;

  const Button.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.width,
    this.height = 48,
    this.fontSize = 16,
    this.color,
    this.disabled = false,
  }) : _isFilled = false;

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.primary;

    if (_isFilled) {
      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _content(),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: disabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: btnColor,
          side: BorderSide(color: btnColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _content(),
      ),
    );
  }

  Widget _content() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
