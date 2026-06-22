import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../order/order_detail_page.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xCC1D293D),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 130,
                    height: 124,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.accentSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Payment Successful', style: AppTextStyles.h2),
                  const SizedBox(height: 8),
                  Text(
                    'You paid \$${total.toStringAsFixed(2)}. Your order is being processed and will ship soon.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMuted,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 47,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .popUntil((r) => r.isFirst);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              foregroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23.5),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            child: const Text('Home'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: 'View Order',
                          height: 48,
                          borderRadius: 24,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const OrderDetailPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
