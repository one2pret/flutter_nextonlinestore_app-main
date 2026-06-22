import 'package:flutter/material.dart';

class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  final _controller = PageController();
  int _index = 0;

  static const _slides = <_BannerSlide>[
    _BannerSlide(
      title: 'Mega Sale\nUp to 70% Off',
      subtitle: 'Shop the latest collection',
      gradient: [Color(0xFF2FA084), Color(0xFF1F6F5F)],
    ),
    _BannerSlide(
      title: 'New Arrivals',
      subtitle: 'Discover this season trends',
      gradient: [Color(0xFF6FCF97), Color(0xFF2FA084)],
    ),
    _BannerSlide(
      title: 'Free Shipping',
      subtitle: 'For all orders above \$50',
      gradient: [Color(0xFF1F6F5F), Color(0xFF154A40)],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 182,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _index = i),
            itemCount: _slides.length,
            itemBuilder: (_, i) => _BannerCard(slide: _slides[i]),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (i) {
            final active = i == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF1F2A2E)
                    : const Color(0xFF1F2A2E).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BannerSlide {
  const _BannerSlide({
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final List<Color> gradient;
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.slide});

  final _BannerSlide slide;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: slide.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            slide.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            slide.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Shop Now',
              style: TextStyle(
                color: Color(0xFF1F2A2E),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
