import 'package:flutter/material.dart';

import '../../core/components/section_header.dart';
import '../../core/theme/app_colors.dart';
import '../cart/cart_page.dart';
import '../categories/categories_page.dart';
import '../profile/profile_page.dart';
import '../wishlist/wishlist_page.dart';
import 'widgets/category_strip.dart';
import 'widgets/featured_row.dart';
import 'widgets/header_bar.dart';
import 'widgets/hero_banner.dart';
import 'widgets/product_card_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const HeaderBar(),
            const HeroBanner(),
            const SizedBox(height: 12),
            const CategoryStrip(),
            const SizedBox(height: 4),
            SectionHeader(
              title: 'Flash Deals',
              subtitle: 'Limited time offers',
              onSeeAll: () {},
            ),
            const FeaturedRow(),
            SectionHeader(
              title: 'Best Sellers',
              subtitle: 'Top picks for you',
              onSeeAll: () {},
            ),
            const ProductCardRow(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CategoriesPage()),
            );
          } else if (i == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CartPage()),
            );
          } else if (i == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WishlistPage()),
            );
          } else if (i == 4) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = <_NavItem>[
    _NavItem('Home', Icons.home_outlined, Icons.home),
    _NavItem('Categories', Icons.grid_view_outlined, Icons.grid_view),
    _NavItem('Cart', Icons.shopping_cart_outlined, Icons.shopping_cart),
    _NavItem('Wishlist', Icons.favorite_border, Icons.favorite),
    _NavItem('Profile', Icons.person_outline, Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = i == currentIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          active ? item.activeIcon : item.icon,
                          size: 22,
                          color: active
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w500,
                            color: active
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}


class _NavItem {
  const _NavItem(this.label, this.icon, this.activeIcon);

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
