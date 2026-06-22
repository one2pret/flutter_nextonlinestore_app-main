import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    this.compact = false,
    this.minusBg,
    this.plusBg,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool compact;
  final Color? minusBg;
  final Color? plusBg;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SquareBtn(
            icon: Icons.remove,
            bg: minusBg ?? const Color(0xFFF5F5F5),
            iconColor: AppColors.textPrimary,
            onTap: onMinus,
          ),
          const SizedBox(width: 10),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 10),
          _SquareBtn(
            icon: Icons.add,
            bg: plusBg ?? AppColors.primary,
            iconColor: Colors.white,
            onTap: onPlus,
          ),
        ],
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderSoft),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconBtn(icon: Icons.remove, onTap: onMinus),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _IconBtn(icon: Icons.add, onTap: onPlus),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }
}

class _SquareBtn extends StatelessWidget {
  const _SquareBtn({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color bg;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: iconColor),
      ),
    );
  }
}
