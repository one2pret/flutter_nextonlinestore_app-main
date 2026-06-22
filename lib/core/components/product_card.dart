import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'price_text.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageColor,
    this.oldPrice,
    this.discount,
    this.rating,
    this.sold,
    this.onTap,
    this.onFavorite,
    this.width = 130,
    this.imageHeight = 130,
  });

  final String name;
  final String price;
  final String? oldPrice;
  final String? discount;
  final double? rating;
  final String? sold;
  final Color imageColor;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final double width;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: imageHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: imageColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.shopping_bag_outlined,
                        color: Colors.white70, size: 36),
                  ),
                ),
                if (discount != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        discount!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                if (onFavorite != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavorite,
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_border,
                            size: 14, color: AppColors.textPrimary),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.productName,
                  ),
                  const SizedBox(height: 6),
                  if (rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 11, color: AppColors.star),
                        const SizedBox(width: 2),
                        Text(
                          '$rating',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (sold != null) ...[
                          const SizedBox(width: 4),
                          Text('. $sold', style: AppTextStyles.small),
                        ],
                      ],
                    ),
                  const SizedBox(height: 8),
                  PriceText(price: price, oldPrice: oldPrice),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
