import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage({super.key, required this.productName});

  final String productName;

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int _rating = 0;
  final _comment = TextEditingController();
  final _tags = <String>{};

  static const _availableTags = [
    'Great quality',
    'Fast shipping',
    'As described',
    'Good packaging',
    'Recommended',
    'Value for money',
  ];

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a rating')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thanks! Your review has been submitted.'),
        duration: Duration(seconds: 1),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Write Review'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text(widget.productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.h2),
          const SizedBox(height: 6),
          const Text(
            'Share your experience with other shoppers.',
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: 24),
          const Text('Rate this product', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < _rating;
              return GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    filled ? Icons.star : Icons.star_border,
                    size: 40,
                    color: filled
                        ? AppColors.star
                        : AppColors.textMuted,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          if (_rating > 0)
            Center(
              child: Text(
                _ratingLabel(_rating),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text('What did you like?', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTags
                .map(
                  (t) => GestureDetector(
                    onTap: () => setState(() {
                      if (_tags.contains(t)) {
                        _tags.remove(t);
                      } else {
                        _tags.add(t);
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: _tags.contains(t)
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _tags.contains(t)
                              ? AppColors.primary
                              : AppColors.borderSoft,
                        ),
                      ),
                      child: Text(
                        t,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _tags.contains(t)
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          const Text('Your review', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 10),
          TextField(
            controller: _comment,
            maxLines: 5,
            maxLength: 500,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Tell others what you think about this product...',
              hintStyle: AppTextStyles.bodyMuted,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderSoft),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined,
                      size: 18, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Add photos (optional)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Submit Review',
            onPressed: _submit,
            height: 49,
            borderRadius: 24.5,
          ),
        ],
      ),
    );
  }

  String _ratingLabel(int r) => switch (r) {
        1 => 'Very Bad',
        2 => 'Bad',
        3 => 'Okay',
        4 => 'Good',
        _ => 'Excellent!',
      };
}
