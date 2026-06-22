import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/guest_prompt_view.dart';
import '../../../core/components/spaces.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/currency_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../data/models/response/cart_response_model.dart';
import '../../checkout/pages/checkout_page.dart';
import '../bloc/cart_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
      context.read<CartBloc>().add(const CartEvent.getCart());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Keranjang')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_isLoggedIn == false) {
      return Scaffold(
        appBar: AppBar(title: const Text('Keranjang')),
        body: const GuestPromptView(
          message: 'Silakan masuk untuk melihat keranjang belanja Anda.',
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: Text(message)),
            loaded: (items) =>
                items.isEmpty ? _buildEmpty() : _buildList(items),
            orElse: () => const SizedBox(),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (items) => items.isEmpty
                ? const SizedBox.shrink()
                : _buildCheckoutBar(items),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: AppColors.grey.withValues(alpha: 0.5)),
          const SpaceHeight(16),
          const Text('Keranjang kamu kosong',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SpaceHeight(8),
          const Text('Yuk mulai belanja!',
              style: TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }

  Widget _buildList(List<CartItem> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SpaceHeight(12),
      itemBuilder: (context, i) => _cartItemTile(items[i]),
    );
  }

  Widget _cartItemTile(CartItem item) {
    final product = item.product;
    final qty = item.quantity ?? 1;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 72,
              height: 72,
              child: product?.imageUrl != null && product!.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.imageUrl, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.slate50,
                      child: const Icon(Icons.image_outlined),
                    ),
            ),
          ),
          const SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SpaceHeight(4),
                Text(
                  (product?.price ?? '0').toRupiah,
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
                const SpaceHeight(8),
                Row(
                  children: [
                    _qtyButton(Icons.remove, () {
                      if (qty > 1) {
                        context.read<CartBloc>().add(
                              CartEvent.updateCartItem(
                                  id: item.id!, quantity: qty - 1),
                            );
                      } else {
                        context
                            .read<CartBloc>()
                            .add(CartEvent.removeCartItem(item.id!));
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('$qty',
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    _qtyButton(Icons.add, () {
                      context.read<CartBloc>().add(
                            CartEvent.updateCartItem(
                                id: item.id!, quantity: qty + 1),
                          );
                    }),
                    const Spacer(),
                    IconButton(
                      onPressed: () => context
                          .read<CartBloc>()
                          .add(CartEvent.removeCartItem(item.id!)),
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }

  Widget _buildCheckoutBar(List<CartItem> items) {
    final total = items.fold<double>(
      0,
      (sum, item) =>
          sum +
          ((item.product?.price ?? '0').toPrice * (item.quantity ?? 1)),
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total',
                    style: TextStyle(fontSize: 12, color: AppColors.grey)),
                Text(
                  total.currencyFormatRp,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SpaceWidth(16),
            Expanded(
              child: Button.filled(
                onPressed: () => context.push(const CheckoutPage()),
                label: 'Checkout',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
