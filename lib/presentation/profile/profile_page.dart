import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../address/address_list_page.dart';
import '../auth/auth_session.dart';
import '../auth/login_page.dart';
import '../help/help_page.dart';
import '../notifications/notifications_page.dart';
import '../order/orders_list_page.dart';
import '../wishlist/wishlist_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = AuthSession.instance.user;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          GestureDetector(
            onTap: user == null
                ? null
                : () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ))
                        .then((_) => setState(() {}));
                  },
            child: _ProfileHeader(user: user),
          ),
          const SizedBox(height: 16),
          if (user != null) const _StatsRow(),
          const SizedBox(height: 16),
          _MenuGroup(
            title: 'My Account',
            items: [
              _MenuItem(
                icon: Icons.shopping_bag_outlined,
                label: 'My Orders',
                trailing: '3 active',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OrdersListPage(),
                    ),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.favorite_border,
                label: 'Wishlist',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WishlistPage()),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.location_on_outlined,
                label: 'Addresses',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AddressListPage(),
                    ),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.payment,
                label: 'Payment Methods',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 14),
          _MenuGroup(
            title: 'Preferences',
            items: [
              _MenuItem(
                icon: Icons.notifications_none,
                label: 'Notifications',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.language,
                label: 'Language',
                trailing: 'English',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.dark_mode_outlined,
                label: 'Appearance',
                trailing: 'Light',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 14),
          _MenuGroup(
            title: 'Support',
            items: [
              _MenuItem(
                icon: Icons.help_outline,
                label: 'Help Center',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HelpPage()),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.info_outline,
                label: 'About',
                trailing: 'v1.0.0',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (user != null)
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  AuthSession.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (r) => false,
                  );
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                icon: const Icon(Icons.login, size: 18),
                label: const Text('Sign In / Sign Up'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});
  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Guest',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.email ?? 'Not signed in',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                if (user != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Gold Member',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (user != null)
            const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: const [
          Expanded(child: _Stat(label: 'Orders', value: '12')),
          _VDivider(),
          Expanded(child: _Stat(label: 'Wishlist', value: '8')),
          _VDivider(),
          Expanded(child: _Stat(label: 'Reward Pts', value: '1.2k')),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _VDivider extends StatelessWidget {
  const _VDivider();
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: AppColors.divider);
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? trailing;
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.title, required this.items});
  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: AppTextStyles.sectionTitle),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0)
                  const Divider(height: 1, color: AppColors.divider),
                InkWell(
                  onTap: items[i].onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.accentSoft,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(items[i].icon,
                              size: 16, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            items[i].label,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (items[i].trailing != null) ...[
                          Text(items[i].trailing!,
                              style: AppTextStyles.caption),
                          const SizedBox(width: 6),
                        ],
                        const Icon(Icons.chevron_right,
                            size: 18, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
