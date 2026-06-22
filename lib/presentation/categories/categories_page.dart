import 'package:flutter/material.dart';

import '../../core/components/search_field.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../search/search_page.dart';
import 'category_data.dart';
import 'category_detail_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Categories'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          AppSearchField(
            hint: 'Search categories...',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
          ),
          const SizedBox(height: 18),
          const Text('Browse all', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (_, i) => _CategoryTile(item: categories[i]),
          ),
          const SizedBox(height: 24),
          const Text('Featured collections',
              style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          ..._featured.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FeaturedTile(item: f),
            ),
          ),
        ],
      ),
    );
  }

  static const _featured = <_FeaturedItem>[
    _FeaturedItem(
      title: 'New Arrivals',
      subtitle: 'Fresh picks updated every week',
      categoryId: 'fashion',
      gradient: [Color(0xFF2FA084), Color(0xFF1F6F5F)],
    ),
    _FeaturedItem(
      title: 'Weekend Deals',
      subtitle: 'Up to 50% off across categories',
      categoryId: 'gadget',
      gradient: [Color(0xFF6FCF97), Color(0xFF2FA084)],
    ),
    _FeaturedItem(
      title: 'Best for Home',
      subtitle: 'Cozy essentials & decor',
      categoryId: 'home',
      gradient: [Color(0xFF1F6F5F), Color(0xFF154A40)],
    ),
  ];
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.item});

  final CategoryItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CategoryDetailPage(category: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: item.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.fg, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedItem {
  const _FeaturedItem({
    required this.title,
    required this.subtitle,
    required this.categoryId,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final String categoryId;
  final List<Color> gradient;
}

class _FeaturedTile extends StatelessWidget {
  const _FeaturedTile({required this.item});

  final _FeaturedItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final cat = categories.firstWhere((c) => c.id == item.categoryId);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CategoryDetailPage(category: cat),
          ),
        );
      },
      child: Container(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: item.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward,
                  size: 18, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
