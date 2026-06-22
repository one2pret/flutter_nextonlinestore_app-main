import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'chat_support_page.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const _categories = <_HelpCategory>[
    _HelpCategory('Orders & Tracking', Icons.shopping_bag_outlined),
    _HelpCategory('Payment & Refund', Icons.payment),
    _HelpCategory('Shipping', Icons.local_shipping_outlined),
    _HelpCategory('Account', Icons.person_outline),
    _HelpCategory('Returns', Icons.assignment_return_outlined),
    _HelpCategory('Promo & Voucher', Icons.local_offer_outlined),
  ];

  static const _faqs = <_Faq>[
    _Faq(
      question: 'How do I track my order?',
      answer:
          'Open Profile → My Orders, choose the order, then tap "Track Order" to see live status.',
    ),
    _Faq(
      question: 'What payment methods are supported?',
      answer:
          'We accept credit/debit cards, e-wallets (GoPay, OVO, DANA), and bank transfer.',
    ),
    _Faq(
      question: 'How long does shipping take?',
      answer:
          'Standard 5–7 days, Express 2–3 days, Same Day delivery available in selected cities.',
    ),
    _Faq(
      question: 'How do I return an item?',
      answer:
          'Go to the order detail page within 7 days of delivery and tap "Request Return".',
    ),
    _Faq(
      question: 'Can I cancel my order?',
      answer:
          'Yes, as long as the order has not been shipped. Open order detail → "Cancel Order".',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Help Center'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          _ContactCard(),
          const SizedBox(height: 20),
          const Text('Browse topics', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, i) {
              final c = _categories[i];
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(c.icon, color: AppColors.primary, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      c.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text('Frequently asked questions',
              style: AppTextStyles.sectionTitle),
          const SizedBox(height: 10),
          ..._faqs.map((f) => _FaqTile(faq: f)),
        ],
      ),
    );
  }
}

class _HelpCategory {
  const _HelpCategory(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _Faq {
  const _Faq({required this.question, required this.answer});
  final String question;
  final String answer;
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.faq});
  final _Faq faq;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          childrenPadding:
              const EdgeInsets.fromLTRB(14, 0, 14, 14),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textMuted,
          title: Text(
            faq.question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(faq.answer, style: AppTextStyles.bodyMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.support_agent,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need more help?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Chat with our support agent 24/7',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChatSupportPage(),
                ),
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Chat',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
