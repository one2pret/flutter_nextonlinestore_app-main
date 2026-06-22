import 'package:flutter/material.dart';

import '../../core/components/product_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../product_detail/product_detail_page.dart';
import 'wishlist_store.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    WishlistStore.instance.addListener(_refresh);
  }

  @override
  void dispose() {
    WishlistStore.instance.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final items = WishlistStore.instance.items;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Wishlist'),
        actions: [
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(
                  '${items.length} items',
                  style: AppTextStyles.caption,
                ),
              ),
            ),
        ],
      ),
      body: items.isEmpty
          ? const _EmptyState()
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (_, i) {
                final p = items[i];
                return Stack(
                  children: [
                    ProductCard(
                      name: p.name,
                      price: p.price,
                      oldPrice: p.oldPrice,
                      discount: p.discount,
                      rating: p.rating,
                      sold: p.sold,
                      imageColor: p.color,
                      width: double.infinity,
                      imageHeight: 160,
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
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => WishlistStore.instance.remove(p.name),
                        child: Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border,
                  color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 14),
            const Text('No favorites yet', style: AppTextStyles.h2),
            const SizedBox(height: 6),
            const Text(
              'Tap the heart on any product to save it for later.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
