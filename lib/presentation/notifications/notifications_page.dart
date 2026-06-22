import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static final _items = <_Notif>[
    _Notif(
      title: 'Order Shipped',
      message: 'Your order #NXT-23198 is on the way. Estimated tomorrow.',
      time: '10m ago',
      icon: Icons.local_shipping_outlined,
      color: AppColors.primary,
      unread: true,
      category: 'Orders',
    ),
    _Notif(
      title: 'Payment Successful',
      message: 'We received \$173.09 for order #NXT-23198.',
      time: '12m ago',
      icon: Icons.check_circle_outline,
      color: const Color(0xFF11998E),
      unread: true,
      category: 'Payments',
    ),
    _Notif(
      title: 'Flash Sale starts at 8 PM',
      message: 'Up to 70% off on selected fashion items. Set a reminder.',
      time: '2h ago',
      icon: Icons.local_fire_department_outlined,
      color: Color(0xFFEF6C2E),
      unread: false,
      category: 'Promo',
    ),
    _Notif(
      title: 'New review on your wishlist',
      message: 'Wireless Headphone got a 5-star review from Jane.',
      time: 'Yesterday',
      icon: Icons.star_outline,
      color: Color(0xFFE99B00),
      unread: false,
      category: 'Activity',
    ),
    _Notif(
      title: 'Welcome to Next Online Store',
      message: 'Your account is ready. Enjoy your first order discount!',
      time: '2 days ago',
      icon: Icons.celebration_outlined,
      color: Color(0xFF6B4EE6),
      unread: false,
      category: 'Account',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _items.where((e) => e.unread).length;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (final n in _items) {
                  n.unread = false;
                }
              });
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (unread > 0)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'You have $unread unread notification${unread > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                return _NotifTile(
                  notif: _items[i],
                  onTap: () => setState(() => _items[i].unread = false),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Notif {
  _Notif({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    required this.unread,
    required this.category,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  bool unread;
  final String category;
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.notif, required this.onTap});

  final _Notif notif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notif.unread ? AppColors.accentSoft : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: notif.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(notif.icon, size: 18, color: notif.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (notif.unread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notif.message, style: AppTextStyles.bodyMuted),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(notif.category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          )),
                      const SizedBox(width: 6),
                      Text('· ${notif.time}', style: AppTextStyles.small),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
