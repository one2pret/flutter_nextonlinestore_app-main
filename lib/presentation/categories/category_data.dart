import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.subcategories,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color bg;
  final Color fg;
  final List<String> subcategories;
}

const categories = <CategoryItem>[
  CategoryItem(
    id: 'fashion',
    name: 'Fashion',
    icon: Icons.checkroom,
    bg: AppColors.accentSoft,
    fg: AppColors.primary,
    subcategories: ['All', 'Men', 'Women', 'Kids', 'Shoes', 'Bags'],
  ),
  CategoryItem(
    id: 'beauty',
    name: 'Beauty',
    icon: Icons.face_retouching_natural,
    bg: Color(0xFFFFF4E0),
    fg: Color(0xFFE99B00),
    subcategories: ['All', 'Skincare', 'Makeup', 'Fragrance', 'Hair'],
  ),
  CategoryItem(
    id: 'gadget',
    name: 'Gadget',
    icon: Icons.phone_iphone,
    bg: Color(0xFFE7F1FF),
    fg: Color(0xFF1E5BAA),
    subcategories: ['All', 'Phones', 'Audio', 'Wearables', 'Accessories'],
  ),
  CategoryItem(
    id: 'home',
    name: 'Home',
    icon: Icons.chair_alt,
    bg: Color(0xFFE6F7F1),
    fg: Color(0xFF11998E),
    subcategories: ['All', 'Furniture', 'Kitchen', 'Decor', 'Bedding'],
  ),
  CategoryItem(
    id: 'sports',
    name: 'Sports',
    icon: Icons.sports_basketball,
    bg: Color(0xFFFFEDE5),
    fg: Color(0xFFEF6C2E),
    subcategories: ['All', 'Footwear', 'Apparel', 'Equipment', 'Outdoor'],
  ),
  CategoryItem(
    id: 'grocery',
    name: 'Grocery',
    icon: Icons.local_grocery_store_outlined,
    bg: Color(0xFFFCEAEA),
    fg: Color(0xFFDC2855),
    subcategories: ['All', 'Snacks', 'Drinks', 'Frozen', 'Fresh'],
  ),
  CategoryItem(
    id: 'kids',
    name: 'Kids & Toys',
    icon: Icons.toys_outlined,
    bg: Color(0xFFF1ECFF),
    fg: Color(0xFF6B4EE6),
    subcategories: ['All', 'Toys', 'School', 'Baby Care'],
  ),
  CategoryItem(
    id: 'pet',
    name: 'Pet Supplies',
    icon: Icons.pets,
    bg: Color(0xFFFFF1DE),
    fg: Color(0xFFAD7A21),
    subcategories: ['All', 'Food', 'Toys', 'Care'],
  ),
];

class CategoryProduct {
  const CategoryProduct({
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

List<CategoryProduct> productsFor(String categoryId) {
  final palette = const [
    Color(0xFFFEEAEE),
    Color(0xFFE6F0FF),
    Color(0xFFFFF1DE),
    Color(0xFFE6F4EC),
    Color(0xFFF1ECFF),
    Color(0xFFFFEDE5),
  ];
  final base = _seedNames[categoryId] ?? const ['Item A', 'Item B', 'Item C'];
  return List.generate(base.length * 2, (i) {
    final name = base[i % base.length];
    final price = 19 + (i * 7) % 80;
    final old = price + 15 + (i * 3) % 20;
    final discount = ((old - price) / old * 100).round();
    return CategoryProduct(
      name: i < base.length ? name : '$name Pro',
      price: '\$$price.00',
      oldPrice: '\$$old.00',
      discount: '-$discount%',
      rating: 4.5 + (i % 5) * 0.1,
      sold: '${(i + 1) * 230} sold',
      color: palette[i % palette.length],
    );
  });
}

const _seedNames = <String, List<String>>{
  'fashion': [
    'Casual T-Shirt',
    'Denim Jacket',
    'Slim Chino',
    'Hoodie Premium',
    'Linen Shirt',
  ],
  'beauty': [
    'Lipstick Matte',
    'Hydrating Serum',
    'Face Mask',
    'Foundation Light',
    'Perfume Mist',
  ],
  'gadget': [
    'Wireless Headphone',
    'Smart Watch',
    'Power Bank 20K',
    'Bluetooth Speaker',
    'Phone Case',
  ],
  'home': [
    'Floor Lamp',
    'Throw Pillow',
    'Kitchen Knife',
    'Wall Clock',
    'Bedding Set',
  ],
  'sports': [
    'Running Shoes',
    'Yoga Mat',
    'Dumbbell Pair',
    'Sports Bottle',
    'Training Tee',
  ],
  'grocery': [
    'Premium Coffee',
    'Granola Pack',
    'Olive Oil',
    'Dark Chocolate',
    'Instant Noodle',
  ],
  'kids': [
    'Building Blocks',
    'Plush Bear',
    'Coloring Set',
    'Toy Car',
    'Storybook',
  ],
  'pet': [
    'Cat Food 2kg',
    'Dog Collar',
    'Pet Bed',
    'Scratch Post',
    'Chew Toy',
  ],
};
