import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.oldPrice,
    this.large = false,
    this.inline = false,
  });

  final String price;
  final String? oldPrice;
  final bool large;
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final priceStyle = large ? AppTextStyles.priceLarge : AppTextStyles.price;
    if (oldPrice == null) {
      return Text(price, style: priceStyle);
    }
    if (inline) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(price, style: priceStyle),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(oldPrice!, style: AppTextStyles.priceStrike),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(price, style: priceStyle),
        Text(oldPrice!, style: AppTextStyles.priceStrike),
      ],
    );
  }
}
