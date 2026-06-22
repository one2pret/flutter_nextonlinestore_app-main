import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide Banner;

import '../../../core/theme/app_colors.dart';
import '../../../data/models/response/banner_response_model.dart';

class BannerSliderWidget extends StatefulWidget {
  final List<Banner> banners;
  const BannerSliderWidget({super.key, required this.banners});

  @override
  State<BannerSliderWidget> createState() => _BannerSliderWidgetState();
}

class _BannerSliderWidgetState extends State<BannerSliderWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox();

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160,
            viewportFraction: 0.92,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            onPageChanged: (i, _) => setState(() => _current = i),
          ),
          items: widget.banners
              .map((b) => ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: b.image ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.banners.asMap().entries.map((entry) {
            final active = entry.key == _current;
            return Container(
              width: active ? 16 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary
                    : AppColors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
