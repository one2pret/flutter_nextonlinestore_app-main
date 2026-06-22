import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAllTap;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.darkGrey),
                  ),
                ],
              ],
            ),
          ),
          if (onSeeAllTap != null)
            GestureDetector(
              onTap: onSeeAllTap,
              child: const Text(
                'Lihat Semua >',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
