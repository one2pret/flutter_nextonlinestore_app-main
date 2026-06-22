import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, this.total = 173.09});

  final double total;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selected = 'visa';

  static const _groups = <_Group>[
    _Group('Credit / Debit Card', [
      _Method('visa', 'Visa **** 4242', Icons.credit_card),
      _Method('master', 'Mastercard **** 1881', Icons.credit_card),
    ]),
    _Group('E-Wallet', [
      _Method('gopay', 'GoPay', Icons.account_balance_wallet_outlined),
      _Method('ovo', 'OVO', Icons.account_balance_wallet_outlined),
      _Method('dana', 'DANA', Icons.account_balance_wallet_outlined),
    ]),
    _Group('Bank Transfer', [
      _Method('bca', 'BCA Virtual Account', Icons.account_balance),
      _Method('mandiri', 'Mandiri Virtual Account', Icons.account_balance),
    ]),
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
        title: const Text('Payment'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          for (final g in _groups) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 10),
              child: Text(g.title, style: AppTextStyles.sectionTitle),
            ),
            ...g.methods.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MethodTile(
                  method: m,
                  selected: _selected == m.id,
                  onTap: () => setState(() => _selected = m.id),
                ),
              ),
            ),
          ],
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
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text('Total to Pay',
                        style: AppTextStyles.bodyMuted),
                    const Spacer(),
                    Text(
                      '\$${widget.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                PrimaryButton(
                  label: 'Pay Now',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) =>
                            PaymentSuccessPage(total: widget.total),
                      ),
                    );
                  },
                  height: 49,
                  borderRadius: 24.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Group {
  const _Group(this.title, this.methods);
  final String title;
  final List<_Method> methods;
}

class _Method {
  const _Method(this.id, this.name, this.icon);
  final String id;
  final String name;
  final IconData icon;
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final _Method method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentSoft : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderSoft,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : const Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                method.icon,
                size: 18,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                method.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 18,
              color: selected ? AppColors.primary : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
