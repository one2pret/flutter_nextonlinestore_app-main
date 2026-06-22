import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'write_review_page.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key, required this.productName});

  final String productName;

  static const _stats = <int>[58, 22, 12, 5, 3];

  static const _reviews = <_Review>[
    _Review(
      name: 'Jane S.',
      rating: 5,
      comment:
          'Quality is amazing, packaging was perfect. Will buy again from this seller!',
      time: '2 days ago',
      verified: true,
    ),
    _Review(
      name: 'Andre K.',
      rating: 4,
      comment: 'Item as described. Shipping was a bit slow but otherwise great.',
      time: '1 week ago',
      verified: true,
    ),
    _Review(
      name: 'Lia P.',
      rating: 5,
      comment: 'Love it! Color matches the photo and feels premium.',
      time: '2 weeks ago',
      verified: false,
    ),
    _Review(
      name: 'Reza M.',
      rating: 3,
      comment: 'Good but not great. Size runs slightly smaller than expected.',
      time: '1 month ago',
      verified: true,
    ),
  ];

  double get _average {
    var total = 0;
    var count = 0;
    for (var i = 0; i < _stats.length; i++) {
      total += _stats[i] * (5 - i);
      count += _stats[i];
    }
    return count == 0 ? 0 : total / count;
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = _stats.fold<int>(0, (a, b) => a + b);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Reviews & Ratings'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      _average.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (i) {
                        return Icon(
                          i < _average.round() ? Icons.star : Icons.star_border,
                          color: AppColors.star,
                          size: 14,
                        );
                      }),
                    ),
                    const SizedBox(height: 2),
                    Text('$totalCount reviews',
                        style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: List.generate(5, (i) {
                      final stars = 5 - i;
                      final count = _stats[i];
                      final pct = totalCount == 0 ? 0.0 : count / totalCount;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Row(
                          children: [
                            Text('$stars',
                                style: AppTextStyles.caption),
                            const SizedBox(width: 4),
                            const Icon(Icons.star,
                                size: 10, color: AppColors.star),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  minHeight: 6,
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.5),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 24,
                              child: Text(
                                '$count',
                                textAlign: TextAlign.right,
                                style: AppTextStyles.caption,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text('All reviews', style: AppTextStyles.sectionTitle),
              ),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Icon(Icons.tune, size: 14, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._reviews.map((r) => _ReviewTile(review: r)),
        ],
      ),
      bottomNavigationBar: Container(
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
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: PrimaryButton(
              label: 'Write a Review',
              icon: Icons.edit_outlined,
              height: 49,
              borderRadius: 24.5,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WriteReviewPage(productName: productName),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Review {
  const _Review({
    required this.name,
    required this.rating,
    required this.comment,
    required this.time,
    required this.verified,
  });

  final String name;
  final int rating;
  final String comment;
  final String time;
  final bool verified;
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});
  final _Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person,
                    color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (review.verified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.accentSoft,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(review.time, style: AppTextStyles.small),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating ? Icons.star : Icons.star_border,
                    size: 12,
                    color: AppColors.star,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(review.comment, style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }
}
