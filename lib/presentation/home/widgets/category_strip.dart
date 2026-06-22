import 'package:flutter/material.dart';

import '../../categories/categories_page.dart';
import '../../categories/category_data.dart';
import '../../categories/category_detail_page.dart';

class CategoryStrip extends StatelessWidget {
  const CategoryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final visible = categories.take(5).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final c in visible)
            _CategoryButton(
              label: c.name,
              icon: c.icon,
              bg: c.bg,
              fg: c.fg,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoryDetailPage(category: c),
                  ),
                );
              },
            ),
          _CategoryButton(
            label: 'More',
            icon: Icons.apps,
            bg: const Color(0xFFF1ECFF),
            fg: const Color(0xFF6B4EE6),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CategoriesPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: fg, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF1F2A2E),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
