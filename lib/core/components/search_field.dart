import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.hint = 'Search products...',
    this.onTap,
    this.height = 36,
  });

  final String hint;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFCFDFDC)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                hint,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
