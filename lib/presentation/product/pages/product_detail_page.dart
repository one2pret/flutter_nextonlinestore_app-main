import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/currency_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/response/product_response_model.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/pages/cart_page.dart';
import '../../checkout/pages/checkout_page.dart';
import '../bloc/product_detail_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Product _product;
  bool _isAddingToCart = false;
  bool _isBuyNow = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    if (_product.id != null) {
      context
          .read<ProductDetailBloc>()
          .add(ProductDetailEvent.getProductDetail(_product.id!));
    }
  }

  void _addToCart() {
    if (_product.id == null) return;
    _isAddingToCart = true;
    context
        .read<CartBloc>()
        .add(CartEvent.addToCart(productId: _product.id!));
  }

  void _buyNow() {
    if (_product.id == null) return;
    _isAddingToCart = true;
    _isBuyNow = true;
    context
        .read<CartBloc>()
        .add(CartEvent.addToCart(productId: _product.id!));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductDetailBloc, ProductDetailState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (data) => setState(() => _product = data),
              orElse: () {},
            );
          },
        ),
        BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (_) {
                if (!_isAddingToCart) return;
                _isAddingToCart = false;
                if (_isBuyNow) {
                  _isBuyNow = false;
                  context.push(const CheckoutPage());
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('${_product.name ?? 'Produk'} masuk keranjang'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ));
              },
              error: (msg) {
                _isAddingToCart = false;
                _isBuyNow = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(msg),
                  backgroundColor: AppColors.error,
                ));
              },
              orElse: () {},
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverToBoxAdapter(child: _buildImage()),
                  SliverToBoxAdapter(child: _buildPrice()),
                  SliverToBoxAdapter(child: _buildInfo()),
                  const SliverToBoxAdapter(child: Divider(height: 1)),
                  SliverToBoxAdapter(child: _buildDescription()),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.fromLTRB(8, topPad + 4, 8, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
          ),
          const Spacer(),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final count = state.maybeWhen(
                loaded: (items) => items.length,
                orElse: () => 0,
              );
              return Stack(
                children: [
                  IconButton(
                    onPressed: () => context.push(const CartPage()),
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: AppColors.white),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 340,
      width: double.infinity,
      color: AppColors.slate50,
      child: _product.imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: _product.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (_, _, _) => const Icon(Icons.image_outlined,
                  size: 120, color: AppColors.grey),
            )
          : const Icon(Icons.image_outlined, size: 120, color: AppColors.grey),
    );
  }

  Widget _buildPrice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        (_product.price ?? '0').toRupiah,
        style: GoogleFonts.quicksand(
            fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _product.name ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              const Icon(Icons.star_rounded,
                  size: 15, color: AppColors.warning),
              const Text('4.9',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
              Text('· ${_product.stock ?? 0}+ terjual',
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.grey)),
              if (_product.isFeatured == true)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Unggulan',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Deskripsi Produk',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            _product.description ?? 'Tidak ada deskripsi.',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.darkGrey,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          _detailRow('Berat', '${_product.weight ?? 0} gram'),
          _detailRow('Stok', '${_product.stock ?? 0}'),
          if (_product.category != null)
            _detailRow('Kategori', _product.category!.name ?? '-'),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style:
                    const TextStyle(fontSize: 13, color: AppColors.grey)),
          ),
          Text(': $value',
              style:
                  const TextStyle(fontSize: 13, color: AppColors.darkGrey)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final outOfStock = _product.stock != null && _product.stock! <= 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
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
        child: outOfStock
            ? SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grey),
                  child: const Text('Stok Habis'),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addToCart,
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text('Keranjang'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                        minimumSize: const Size.fromHeight(46),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _buyNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(46),
                      ),
                      child: const Text('Beli Sekarang'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
