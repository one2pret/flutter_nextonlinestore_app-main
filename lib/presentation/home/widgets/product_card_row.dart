import 'package:flutter/material.dart';

import '../../../core/components/product_card.dart';
import '../../product_detail/product_detail_page.dart';

class ProductCardRow extends StatelessWidget {
  const ProductCardRow({super.key});

  static const _items = <_Product>[
    _Product(
      name: 'Wireless Headphone',
      price: '\$89.00',
      oldPrice: '\$120.00',
      discount: '-25%',
      rating: 4.9,
      sold: '2.3k sold',
      color: Color(0xFFFEEAEE),
    ),
    _Product(
      name: 'Smart Watch Pro',
      price: '\$149.00',
      oldPrice: '\$199.00',
      discount: '-15%',
      rating: 4.7,
      sold: '1.1k sold',
      color: Color(0xFFE6F0FF),
    ),
    _Product(
      name: 'Sneakers Classic',
      price: '\$74.00',
      oldPrice: '\$95.00',
      discount: '-20%',
      rating: 4.8,
      sold: '980 sold',
      color: Color(0xFFFFF1DE),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 236,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final item = _items[i];
          return ProductCard(
            name: item.name,
            price: item.price,
            oldPrice: item.oldPrice,
            discount: item.discount,
            rating: item.rating,
            sold: item.sold,
            imageColor: item.color,
            onFavorite: () {},
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(
                    args: ProductDetailArgs(
                      name: item.name,
                      price: item.price,
                      oldPrice: item.oldPrice,
                      discount: item.discount,
                      rating: item.rating,
                      sold: item.sold,
                      color: item.color,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Product {
  const _Product({
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
