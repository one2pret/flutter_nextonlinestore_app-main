import 'package:flutter/material.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/response/order_response_model.dart';
import '../../home/pages/main_page.dart';
import '../../order/pages/order_detail_page.dart';

class PaymentSuccessPage extends StatelessWidget {
  final Order order;
  const PaymentSuccessPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check,
                    size: 64, color: AppColors.white),
              ),
              const SpaceHeight(24),
              const Text(
                'Pembayaran Berhasil!',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SpaceHeight(8),
              Text('Order #${order.orderNumber ?? '-'}'),
              const SpaceHeight(8),
              const Text(
                'Pesanan kamu sudah masuk antrian pengemasan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.darkGrey),
              ),
              const Spacer(),
              Button.filled(
                onPressed: () =>
                    context.push(OrderDetailPage(orderId: order.id!)),
                label: 'Lihat Pesanan',
                width: double.infinity,
              ),
              const SpaceHeight(12),
              Button.outlined(
                onPressed: () =>
                    context.pushAndRemoveUntil(const MainPage()),
                label: 'Kembali ke Home',
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
