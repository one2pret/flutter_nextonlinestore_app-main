import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  static const _steps = <_TrackStep>[
    _TrackStep('Order Placed', 'Today, 09:32', Icons.receipt_long_outlined,
        state: _StepState.active),
    _TrackStep('Shipped', 'Estimated tomorrow', Icons.local_shipping_outlined,
        state: _StepState.next),
    _TrackStep('Delivered', '3 - 5 days', Icons.home_outlined,
        state: _StepState.pending),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Order Detail'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF495AFF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFCFD6DC)),
              ),
              child: const Text(
                'Paid',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF495AFF),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          _OrderHeader(),
          const SizedBox(height: 20),
          _VerticalTracker(steps: _steps),
          const SizedBox(height: 16),
          Text('Items', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 10),
          ..._items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _OrderItemTile(item: e),
              )),
          const SizedBox(height: 12),
          _SummaryCard(
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
            child: PrimaryButton(
              label: 'Track Order',
              icon: Icons.location_searching,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Open tracking details'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              height: 49,
              borderRadius: 24.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_outlined,
              color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Order #NXT-23198',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text('Placed on today, 09:32',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _StepState { active, next, pending }

class _TrackStep {
  const _TrackStep(this.title, this.detail, this.icon, {required this.state});
  final String title;
  final String detail;
  final IconData icon;
  final _StepState state;
}

class _VerticalTracker extends StatelessWidget {
  const _VerticalTracker({required this.steps});

  final List<_TrackStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final last = i == steps.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 38,
                child: Column(
                  children: [
                    _dot(step.state),
                    if (!last)
                      Expanded(
                        child: Container(
                          width: 3,
                          color: step.state == _StepState.pending
                              ? const Color(0xFFCFD6DC)
                              : AppColors.primary,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: last ? 0 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(step.icon,
                              size: 16,
                              color: step.state == _StepState.pending
                                  ? AppColors.textMuted
                                  : AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            step.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: step.state == _StepState.pending
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(step.detail, style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _dot(_StepState state) {
    switch (state) {
      case _StepState.active:
        return Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.1),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const Icon(Icons.check,
              color: AppColors.primary, size: 18),
        );
      case _StepState.next:
        return Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
        );
      case _StepState.pending:
        return Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFCFD6DC), width: 2),
          ),
        );
    }
  }
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
                    Text('x${item.qty}', style: AppTextStyles.caption),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
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
