import 'package:flutter/material.dart';

import '../../core/components/product_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../product_detail/product_detail_page.dart';
import '../search/search_page.dart';
import 'category_data.dart';

class CategoryDetailPage extends StatefulWidget {
  const CategoryDetailPage({super.key, required this.category});

  final CategoryItem category;

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  int _filterIndex = 0;
  String _sort = 'Popular';

  @override
  Widget build(BuildContext context) {
    final products = productsFor(widget.category.id);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _Header(category: widget.category, count: products.length),
          _FilterRow(
            items: widget.category.subcategories,
            selected: _filterIndex,
            onSelect: (i) => setState(() => _filterIndex = i),
          ),
          _SortBar(
            sort: _sort,
            onSortTap: () => _showSortSheet(context),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (_, i) {
                final p = products[i];
                return ProductCard(
                  name: p.name,
                  price: p.price,
                  oldPrice: p.oldPrice,
                  discount: p.discount,
                  rating: p.rating,
                  sold: p.sold,
                  imageColor: p.color,
                  width: double.infinity,
                  imageHeight: 160,
                  onFavorite: () {},
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(
                          args: ProductDetailArgs(
                            name: p.name,
                            price: p.price,
                            oldPrice: p.oldPrice,
                            discount: p.discount,
                            rating: p.rating,
                            sold: p.sold,
                            color: p.color,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) {
        const options = ['Popular', 'Newest', 'Price: Low to High', 'Price: High to Low', 'Best Rating'];
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Sort by', style: AppTextStyles.sectionTitle),
                ),
              ),
              ...options.map(
                (o) => ListTile(
                  title: Text(
                    o,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: _sort == o
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: _sort == o
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  trailing: _sort == o
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _sort = o);
                    Navigator.of(sheetCtx).pop();
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.category, required this.count});

  final CategoryItem category;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: category.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(category.icon, color: category.fg, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$count products available',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final List<String> items;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = i == selected;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? AppColors.primary : AppColors.borderSoft,
                ),
              ),
              child: Text(
                items[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SortBar extends StatelessWidget {
  const _SortBar({required this.sort, required this.onSortTap});

  final String sort;
  final VoidCallback onSortTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onSortTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.swap_vert,
                      size: 16, color: AppColors.textPrimary),
                  const SizedBox(width: 6),
                  Text(
                    sort,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.tune,
                      size: 16, color: AppColors.textPrimary),
                  SizedBox(width: 6),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.grid_view,
                size: 18, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
