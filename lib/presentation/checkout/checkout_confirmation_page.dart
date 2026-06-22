import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../payment/payment_page.dart';

class CheckoutConfirmationPage extends StatelessWidget {
  const CheckoutConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Confirmation'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const _Stepper(),
          const SizedBox(height: 8),
          const _StepLabels(),
          const SizedBox(height: 24),
          _SectionTitle('Order Items'),
          const SizedBox(height: 10),
          ..._items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _OrderItemTile(item: e),
              )),
          const SizedBox(height: 12),
          _SectionTitle('Shipping Address'),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.location_on_outlined,
            title: 'John Doe (+62 812-3456-7890)',
            subtitle:
                'Jl. Sudirman No. 21, RT 03/RW 05, Kebayoran Baru, Jakarta Selatan 12190',
          ),
          const SizedBox(height: 20),
          _SectionTitle('Shipping Method'),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.rocket_launch_outlined,
            title: 'Express',
            subtitle: '2 - 3 days · \$4.99',
          ),
          const SizedBox(height: 20),
          _SectionTitle('Payment Method'),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.credit_card,
            title: 'Visa **** 4242',
            subtitle: 'Card holder: John Doe',
          ),
          const SizedBox(height: 24),
          _SectionTitle('Price Details'),
          const SizedBox(height: 10),
          const _PriceBreakdown(
            subtotal: 162.90,
            shipping: 4.99,
            tax: 5.20,
          ),
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
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Confirm Order',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PaymentPage(),
                        ),
                      );
                    },
                    height: 48,
                    borderRadius: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const _items = <_OrderItem>[
    _OrderItem(
      name: 'Wireless Headphone',
      variant: 'XL · Black',
      price: 89.00,
      qty: 1,
      color: Color(0xFFFEEAEE),
    ),
    _OrderItem(
      name: 'Casual Sneakers',
      variant: 'M · White',
      price: 49.90,
      qty: 1,
      color: Color(0xFFFFF1DE),
    ),
    _OrderItem(
      name: 'Cotton T-Shirt',
      variant: 'L · Grey',
      price: 24.00,
      qty: 1,
      color: Color(0xFFE6F0FF),
    ),
  ];
}


class _Stepper extends StatelessWidget {
  const _Stepper();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          _Dot(done: true),
          Expanded(child: _Line(active: true)),
          _Dot(done: true),
          Expanded(child: _Line(active: true)),
          _Dot(done: true),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.done});
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: done ? AppColors.primary : Colors.transparent,
        shape: BoxShape.circle,
        border: done
            ? null
            : Border.all(color: const Color(0xFFCFD6DC), width: 2),
      ),
      child: done
          ? const Icon(Icons.check, color: Colors.white, size: 20)
          : null,
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      color: active ? AppColors.primary : const Color(0xFFCFD6DC),
    );
  }
}

class _StepLabels extends StatelessWidget {
  const _StepLabels();

  static const _labels = ['Address', 'Shipping', 'Payment'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _labels
          .map(
            (l) => Expanded(
              child: Text(
                l,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTextStyles.sectionTitle);
}

class _OrderItem {
  const _OrderItem({
    required this.name,
    required this.variant,
    required this.price,
    required this.qty,
    required this.color,
  });

  final String name;
  final String variant;
  final double price;
  final int qty;
  final Color color;
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item});

  final _OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined,
                  color: Colors.white70, size: 26),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(item.variant, style: AppTextStyles.caption),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    Text('x${item.qty}',
                        style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodyMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  const _PriceBreakdown({
    required this.subtotal,
    required this.shipping,
    required this.tax,
  });

  final double subtotal;
  final double shipping;
  final double tax;

  double get _total => subtotal + shipping + tax;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _row('Subtotal', subtotal),
          const SizedBox(height: 8),
          _row('Shipping', shipping),
          const SizedBox(height: 8),
          _row('Tax', tax),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.divider),
          ),
          _row('Total', _total, bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    final style = TextStyle(
      fontSize: bold ? 15 : 13,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
      color: bold ? AppColors.primary : AppColors.textPrimary,
    );
    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text('\$${value.toStringAsFixed(2)}', style: style),
      ],
    );
  }
}
