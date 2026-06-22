import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../reviews/reviews_page.dart';
import 'order_detail_page.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  static const _tabs = ['All', 'To Ship', 'Shipping', 'Delivered', 'Cancelled'];

  static final _orders = <_Order>[
    _Order(
      id: 'NXT-23198',
      status: _OrderStatus.shipping,
      itemCount: 3,
      total: 173.09,
      date: 'Today, 09:32',
      preview: 'Wireless Headphone +2 more',
    ),
    _Order(
      id: 'NXT-23145',
      status: _OrderStatus.toShip,
      itemCount: 1,
      total: 89.00,
      date: 'Yesterday, 18:10',
      preview: 'Smart Watch Pro',
    ),
    _Order(
      id: 'NXT-22987',
      status: _OrderStatus.delivered,
      itemCount: 2,
      total: 124.50,
      date: '12 May 2026',
      preview: 'Casual Sneakers, Cotton T-Shirt',
    ),
    _Order(
      id: 'NXT-22810',
      status: _OrderStatus.cancelled,
      itemCount: 1,
      total: 45.00,
      date: '03 May 2026',
      preview: 'Phone Stand',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<_Order> _filter(int idx) {
    if (idx == 0) return _orders;
    final status = switch (idx) {
      1 => _OrderStatus.toShip,
      2 => _OrderStatus.shipping,
      3 => _OrderStatus.delivered,
      4 => _OrderStatus.cancelled,
      _ => null,
    };
    return _orders.where((o) => o.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('My Orders'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tab,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2.5,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: List.generate(_tabs.length, (i) {
          final items = _filter(i);
          if (items.isEmpty) {
            return const Center(
              child: Text('No orders here', style: AppTextStyles.bodyMuted),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, j) => _OrderTile(order: items[j]),
          );
        }),
      ),
    );
  }
}

enum _OrderStatus { toShip, shipping, delivered, cancelled }

extension on _OrderStatus {
  String get label => switch (this) {
        _OrderStatus.toShip => 'To Ship',
        _OrderStatus.shipping => 'Shipping',
        _OrderStatus.delivered => 'Delivered',
        _OrderStatus.cancelled => 'Cancelled',
      };

  Color get color => switch (this) {
        _OrderStatus.toShip => const Color(0xFFE99B00),
        _OrderStatus.shipping => AppColors.primary,
        _OrderStatus.delivered => const Color(0xFF11998E),
        _OrderStatus.cancelled => const Color(0xFFDC2855),
      };

  IconData get icon => switch (this) {
        _OrderStatus.toShip => Icons.inventory_2_outlined,
        _OrderStatus.shipping => Icons.local_shipping_outlined,
        _OrderStatus.delivered => Icons.check_circle_outline,
        _OrderStatus.cancelled => Icons.cancel_outlined,
      };
}

class _Order {
  const _Order({
    required this.id,
    required this.status,
    required this.itemCount,
    required this.total,
    required this.date,
    required this.preview,
  });

  final String id;
  final _OrderStatus status;
  final int itemCount;
  final double total;
  final String date;
  final String preview;
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});
  final _Order order;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: order.status.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(order.status.icon, size: 16, color: order.status.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '#${order.id}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: order.status.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.status.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: order.status.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.preview, style: AppTextStyles.bodyMuted),
          const SizedBox(height: 4),
          Text(
            '${order.itemCount} item(s) · ${order.date}',
            style: AppTextStyles.caption,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.divider),
          ),
          Row(
            children: [
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              if (order.status == _OrderStatus.delivered)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ReviewsPage(productName: order.preview),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 0),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('Review'),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OrderDetailPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
