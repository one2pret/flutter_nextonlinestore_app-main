import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/components/qty_stepper.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_session.dart';
import '../auth/login_page.dart';
import '../checkout/checkout_shipping_page.dart';

class CartItem {
  CartItem({
    required this.name,
    required this.price,
    required this.color,
    this.size = 'XL',
    this.qty = 1,
  });

  final String name;
  final double price;
  final Color color;
  final String size;
  int qty;
}

class CartPage extends StatefulWidget {
  const CartPage({super.key, this.initialItem});

  final CartItem? initialItem;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final List<CartItem> _items;

  static const _primary = Color(0xFF1F6F5F);

  @override
  void initState() {
    super.initState();
    _items = [
      if (widget.initialItem != null) widget.initialItem!,
      CartItem(
        name: 'Casual Sneakers',
        price: 49.90,
        color: const Color(0xFFFFF1DE),
        size: 'M',
      ),
      CartItem(
        name: 'Cotton T-Shirt',
        price: 24.00,
        color: const Color(0xFFE6F0FF),
        size: 'L',
        qty: 2,
      ),
    ];
  }

  double get _subtotal =>
      _items.fold(0, (sum, e) => sum + e.price * e.qty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2A2E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2A2E),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF1F2A2E)),
            onPressed: () {},
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(color: Color(0xFF8C9A97)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _CartTile(
                item: _items[i],
                primary: _primary,
                isFirst: i == 0,
                onPlus: () => setState(() => _items[i].qty++),
                onMinus: () => setState(() {
                  if (_items[i].qty > 1) {
                    _items[i].qty--;
                  } else {
                    _items.removeAt(i);
                  }
                }),
              ),
            ),
      bottomNavigationBar: _CheckoutBar(
        subtotal: _subtotal,
        primary: _primary,
        onCheckout: () {
          if (!AuthSession.instance.isLoggedIn) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please sign in to continue checkout'),
                duration: Duration(seconds: 1),
              ),
            );
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            return;
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CheckoutShippingPage(),
            ),
          );
        },
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({
    required this.item,
    required this.primary,
    required this.isFirst,
    required this.onPlus,
    required this.onMinus,
  });

  final CartItem item;
  final Color primary;
  final bool isFirst;
  final VoidCallback onPlus;
  final VoidCallback onMinus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 104,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 88,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Container(
                width: 72,
                height: 76,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.image_outlined,
                      color: Colors.white70, size: 28),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 88,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2A2E),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.more_vert,
                              size: 16, color: Color(0xFF212429)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Size: ${item.size}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8C9A97),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2A2E),
                        ),
                      ),
                      const Spacer(),
                      QtyStepper(
                        compact: true,
                        value: item.qty,
                        onMinus: onMinus,
                        onPlus: onPlus,
                        plusBg: isFirst ? AppColors.secondary : primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.subtotal,
    required this.primary,
    required this.onCheckout,
  });

  final double subtotal;
  final Color primary;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  const Text(
                    'Subtotal',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8C9A97),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2A2E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                label: 'Checkout',
                onPressed: onCheckout,
                height: 49,
                borderRadius: 24.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
