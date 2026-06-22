import 'package:flutter/material.dart';

class FeaturedRow extends StatelessWidget {
  const FeaturedRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 256,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        children: const [
          _FeatureCardLarge(
            title: 'Summer\nCollection',
            tag: 'New',
            gradient: [Color(0xFFFFB199), Color(0xFFFF6B9D)],
          ),
          SizedBox(width: 8),
          _FeatureCardSmall(
            title: 'Casual Tee',
            price: '\$24.90',
            color: Color(0xFFEFEAE2),
          ),
          SizedBox(width: 8),
          _FeatureCardSmall(
            title: 'Denim Jacket',
            price: '\$59.00',
            color: Color(0xFFE7ECF2),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _FeatureCardLarge extends StatelessWidget {
  const _FeatureCardLarge({
    required this.title,
    required this.tag,
    required this.gradient,
  });

  final String title;
  final String tag;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 137,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F6F5F),
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Shop',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  size: 10,
                  color: Color(0xFF1F6F5F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCardSmall extends StatelessWidget {
  const _FeatureCardSmall({
    required this.title,
    required this.price,
    required this.color,
  });

  final String title;
  final String price;
  final Color color;

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
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, color: Colors.white70, size: 36),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2A2E),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '4.8 - 1.2k sold',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF8C9A97),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  price,
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
