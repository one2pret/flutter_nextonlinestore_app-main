import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class IconWithBadge extends StatelessWidget {
  const IconWithBadge({
    super.key,
    required this.icon,
    this.count,
    this.iconSize = 22,
    this.badgeColor = AppColors.primary,
    this.iconColor = AppColors.textPrimary,
  });

  final IconData icon;
  final String? count;
  final double iconSize;
  final Color badgeColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: iconSize + 2,
      height: iconSize + 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              width: 15,
              height: 15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: count == null
                  ? null
                  : Text(
                      count!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
