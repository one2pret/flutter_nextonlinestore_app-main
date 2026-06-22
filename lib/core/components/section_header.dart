import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'circle_icon_button.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.padding =
        const EdgeInsets.fromLTRB(16, 16, 16, 12),
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onSeeAll != null)
            CircleIconButton(
              icon: Icons.arrow_forward,
              onTap: onSeeAll,
            ),
        ],
      ),
    );
  }
}
