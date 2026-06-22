import 'package:flutter/material.dart';

import '../../core/components/notification_badge.dart';
import '../../core/components/primary_button.dart';
import '../../core/components/qty_stepper.dart';
import '../../core/components/section_header.dart';
import '../cart/cart_page.dart';
import '../reviews/reviews_page.dart';

class ProductDetailArgs {
  const ProductDetailArgs({
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.rating,
    required this.sold,
    required this.color,
  });

  final String name;
  final String price;
  final String oldPrice;
  final String discount;
  final double rating;
  final String sold;
  final Color color;
}

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.args});

  final ProductDetailArgs args;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _sizeIndex = 3;
  int _qty = 1;
  bool _liked = false;

  static const _sizes = ['S', 'M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    final p = widget.args;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _HeroImage(color: p.color),
                  _InfoSection(
                    product: p,
                    liked: _liked,
                    onLike: () => setState(() => _liked = !_liked),
                  ),
                  _SizeSelector(
                    sizes: _sizes,
                    selected: _sizeIndex,
                    onSelect: (i) => setState(() => _sizeIndex = i),
                  ),
                  const _DescriptionSection(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: SectionHeader(
                      title: 'Reviews',
                      subtitle: '4.8 average from 100+ reviews',
                      padding: EdgeInsets.zero,
                      onSeeAll: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ReviewsPage(productName: p.name),
                          ),
                        );
                      },
                    ),
                  ),
                  _RelatedSection(currentName: p.name),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            _BottomActionBar(
              qty: _qty,
              onMinus: () => setState(() => _qty = (_qty - 1).clamp(1, 99)),
              onPlus: () => setState(() => _qty = (_qty + 1).clamp(1, 99)),
              onAddToCart: () {
                final priceValue = double.tryParse(
                      p.price.replaceAll(RegExp(r'[^0-9.]'), ''),
                    ) ??
                    0;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CartPage(
                      initialItem: CartItem(
                        name: p.name,
                        price: priceValue,
                        color: p.color,
                        size: _sizes[_sizeIndex],
                        qty: _qty,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2A2E)),
            onPressed: onBack,
          ),
          const Expanded(
            child: Text(
              'Product Detail',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2A2E),
              ),
            ),
          ),
          const IconWithBadge(
              icon: Icons.shopping_bag_outlined, count: '2'),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: color,
        child: Stack(
          children: [
            const Center(
              child: Icon(Icons.image_outlined,
                  size: 80, color: Colors.white70),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '1 / 5',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.product,
    required this.liked,
    required this.onLike,
  });

  final ProductDetailArgs product;
  final bool liked;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2A2E),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onLike,
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEEF1F0)),
                  ),
                  child: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: liked
                        ? const Color(0xFF1F6F5F)
                        : const Color(0xFF1F2A2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Color(0xFFFFB400)),
              const SizedBox(width: 4),
              Text(
                '${product.rating}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2A2E),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${product.sold})',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8C9A97),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4EC),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  product.discount,
                  style: const TextStyle(
                    color: Color(0xFF1F6F5F),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product.price,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F6F5F),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  product.oldPrice,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8C9A97),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({
    required this.sizes,
    required this.selected,
    required this.onSelect,
  });

  final List<String> sizes;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Size',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2A2E),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(sizes.length, (i) {
              final active = i == selected;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onSelect(i),
                  child: Container(
                    width: 67,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: active
                            ? const Color(0xFF1D293D)
                            : const Color(0xFFEEEEEE),
                        width: active ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      sizes[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w500,
                        color: const Color(0xFF1F2A2E),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2A2E),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'High quality product with premium materials. Designed for daily use with modern style and comfort. Free shipping for selected areas and 7-day return guarantee.',
            style: TextStyle(
              fontSize: 12,
              height: 1.55,
              color: Color(0xFF5A6663),
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedSection extends StatelessWidget {
  const _RelatedSection({required this.currentName});

  final String currentName;

  static const _items = <_RelatedItem>[
    _RelatedItem('Mini Speaker', '\$45.00', Color(0xFFE6F0FF)),
    _RelatedItem('Phone Stand', '\$19.90', Color(0xFFFFF1DE)),
    _RelatedItem('USB Cable', '\$12.50', Color(0xFFE6F7F1)),
    _RelatedItem('Earbuds Lite', '\$35.00', Color(0xFFFEEAEE)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'You may also like', onSeeAll: () {}),
        SizedBox(
          height: 236,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _RelatedCard(item: _items[i]),
          ),
        ),
      ],
    );
  }
}

class _RelatedItem {
  const _RelatedItem(this.name, this.price, this.color);
  final String name;
  final String price;
  final Color color;
}

class _RelatedCard extends StatelessWidget {
  const _RelatedCard({required this.item});

  final _RelatedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 121,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFEEF1F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 121,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: const Center(
              child:
                  Icon(Icons.image_outlined, color: Colors.white70, size: 32),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2A2E),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '4.8 - 800 sold',
                  style:
                      TextStyle(fontSize: 10, color: Color(0xFF8C9A97)),
                ),
                const SizedBox(height: 10),
                Text(
                  item.price,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F6F5F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.qty,
    required this.onMinus,
    required this.onPlus,
    required this.onAddToCart,
  });

  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onAddToCart;

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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              QtyStepper(
                value: qty,
                onMinus: onMinus,
                onPlus: onPlus,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Add to Cart',
                  icon: Icons.shopping_bag_outlined,
                  onPressed: onAddToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

