import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/guest_prompt_view.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/currency_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../data/models/response/order_response_model.dart';
import '../bloc/order_bloc.dart';
import 'order_detail_page.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await AuthLocalDatasource().isLoggedIn();
    if (!mounted) return;
    setState(() => _isLoggedIn = loggedIn);
    if (loggedIn) {
      context.read<OrderBloc>().add(const OrderEvent.getOrders());
    }
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        title: const Text('Pesanan Saya'),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        automaticallyImplyLeading: false,
      );

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == null) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_isLoggedIn == false) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const GuestPromptView(
          message: 'Silakan masuk untuk melihat pesanan Anda.',
        ),
      );
    }
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async =>
            context.read<OrderBloc>().add(const OrderEvent.getOrders()),
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) => state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            listLoaded: (list) => list.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text('Belum ada pesanan')),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _orderTile(list[i]),
                  ),
            error: (msg) => Center(child: Text(msg)),
            orElse: () => const SizedBox(),
          ),
        ),
      ),
    );
  }

  Widget _orderTile(Order o) {
    return InkWell(
      onTap: () => context.push(OrderDetailPage(orderId: o.id!)),
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
            Row(children: [
              Expanded(
                child: Text(
                  o.orderNumber ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _statusBadge(o.status, o.statusLabel),
            ]),
            const SizedBox(height: 8),
            Text(
              '${o.totalItemCount} item · ${(o.total ?? '0').toRupiah}',
              style: const TextStyle(color: AppColors.darkGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String? status, String label) {
    final color = switch (status) {
      'waiting_payment' => AppColors.statusPending,
      'packing' => AppColors.statusPaid,
      'shipping' => AppColors.statusShipping,
      'delivered' => AppColors.statusDelivered,
      'cancelled' => AppColors.statusCancelled,
      'expired' => AppColors.statusExpired,
      _ => AppColors.grey,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
