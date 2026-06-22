import 'package:flutter/material.dart';

@immutable
class WishlistItem {
  const WishlistItem({
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

class WishlistStore extends ChangeNotifier {
  WishlistStore._();
  static final WishlistStore instance = WishlistStore._();

  final List<WishlistItem> _items = [
    const WishlistItem(
      name: 'Wireless Headphone',
      price: '\$89.00',
      oldPrice: '\$120.00',
      discount: '-25%',
      rating: 4.9,
      sold: '2.3k sold',
      color: Color(0xFFFEEAEE),
    ),
    const WishlistItem(
      name: 'Smart Watch Pro',
      price: '\$149.00',
      oldPrice: '\$199.00',
      discount: '-15%',
      rating: 4.7,
      sold: '1.1k sold',
      color: Color(0xFFE6F0FF),
    ),
    const WishlistItem(
      name: 'Sneakers Classic',
      price: '\$74.00',
      oldPrice: '\$95.00',
      discount: '-20%',
      rating: 4.8,
      sold: '980 sold',
      color: Color(0xFFFFF1DE),
    ),
  ];

  List<WishlistItem> get items => List.unmodifiable(_items);

  bool contains(String name) => _items.any((e) => e.name == name);

  void toggle(WishlistItem item) {
    final idx = _items.indexWhere((e) => e.name == item.name);
    if (idx == -1) {
      _items.add(item);
    } else {
      _items.removeAt(idx);
    }
    notifyListeners();
  }

  void remove(String name) {
    _items.removeWhere((e) => e.name == name);
    notifyListeners();
  }
}
