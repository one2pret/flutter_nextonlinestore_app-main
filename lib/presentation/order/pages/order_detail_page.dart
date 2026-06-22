import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/currency_ext.dart';
import '../../../core/extensions/date_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/response/order_response_model.dart';
import '../../checkout/pages/payment_page.dart';
import '../bloc/order_bloc.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<OrderBloc>()
        .add(OrderEvent.getOrderDetail(widget.orderId));
  }

  void _refresh() {
    context
        .read<OrderBloc>()
        .add(OrderEvent.getOrderDetail(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          state.maybeWhen(
            actionSuccess: (msg, paymentUrl) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg)),
              );
              _refresh();
            },
            error: (msg) => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg))),
            orElse: () {},
          );
        },
        builder: (context, state) => state.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          detailLoaded: (o) => _buildDetail(o),
          error: (msg) => Center(child: Text(msg)),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildDetail(Order o) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long, color: AppColors.primary),
                const SpaceWidth(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.statusLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(o.orderNumber ?? '',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpaceHeight(16),
          _section(
            'Item Pesanan',
            Column(
              children: (o.items ?? [])
                  .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            if (item.productImage != null &&
                                item.productImage!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: item.productImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            const SpaceWidth(8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${item.quantity}x · ${(item.price ?? '0').toRupiah}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.darkGrey),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              (item.subtotal ?? '0').toRupiah,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          _section(
            'Alamat Pengiriman',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(o.shippingName ?? '-'),
                Text(o.shippingAddress ?? '-'),
              ],
            ),
          ),
          if (o.shipping != null)
            _section('Tracking', _buildTracking(o.shipping!)),
          _section(
            'Ringkasan',
            Column(
              children: [
                _row('Subtotal', (o.subtotal ?? '0').toRupiah),
                _row('Ongkir', (o.shippingCost ?? '0').toRupiah),
                const Divider(),
                _row('Total', (o.total ?? '0').toRupiah, bold: true),
              ],
            ),
          ),
          const SpaceHeight(16),
          _buildActionButtons(o),
        ],
      ),
    );
  }

  Widget _buildTracking(OrderShipping shipping) {
    final histories = shipping.histories ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kurir: ${shipping.courierName ?? '-'}'),
        if (shipping.waybillId != null) Text('Resi: ${shipping.waybillId}'),
        const SpaceHeight(8),
        if (histories.isEmpty)
          const Text('Belum ada history',
              style: TextStyle(color: AppColors.grey))
        else
          ...histories.map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle,
                        size: 8, color: AppColors.primary),
                    const SpaceWidth(8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h.note ?? h.status ?? ''),
                          if (h.createdAt != null)
                            Text(
                              h.createdAt!.toFormattedDate,
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.grey),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  Widget _buildActionButtons(Order o) {
    final canCancel =
        o.status == 'waiting_payment' || o.status == 'packing';
    final canRepay = o.status == 'expired';
    final canPayNow =
        o.status == 'waiting_payment' && (o.paymentUrl?.isNotEmpty == true);

    return Column(children: [
      if (canPayNow)
        Button.filled(
          onPressed: () => context.push(
              PaymentPage(paymentUrl: o.paymentUrl!, order: o)),
          label: 'Bayar Sekarang',
          width: double.infinity,
        ),
      if (canRepay)
        Button.filled(
          onPressed: () =>
              context.read<OrderBloc>().add(OrderEvent.repayOrder(o.id!)),
          label: 'Bayar Ulang',
          width: double.infinity,
        ),
      if (canCancel) ...[
        const SpaceHeight(8),
        Button.outlined(
          onPressed: () => _confirmCancel(o.id!),
          label: 'Batalkan Pesanan',
          color: AppColors.error,
          width: double.infinity,
        ),
      ],
    ]);
  }

  void _confirmCancel(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Batalkan Pesanan?'),
        content: const Text(
            'Pesanan akan dibatalkan dan tidak bisa dipulihkan.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tidak')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<OrderBloc>().add(OrderEvent.cancelOrder(id));
            },
            child: const Text('Ya, Batalkan',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SpaceHeight(8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontWeight:
                        bold ? FontWeight.bold : FontWeight.normal)),
            Text(value,
                style: TextStyle(
                    fontWeight:
                        bold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      );
}
