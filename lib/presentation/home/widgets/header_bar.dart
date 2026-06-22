import 'package:flutter/material.dart';

import '../../../core/components/notification_badge.dart';
import '../../../core/components/search_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../notifications/notifications_page.dart';
import '../../search/search_page.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: AppSearchField(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          const IconWithBadge(
              icon: Icons.shopping_bag_outlined, count: '2'),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NotificationsPage(),
                ),
              );
            },
            child: const Icon(Icons.notifications_none,
                size: 22, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
