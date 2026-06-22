import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/pages/cart_page.dart';
import '../../product/pages/product_detail_page.dart';
import '../bloc/banner_bloc.dart';
import '../bloc/category_bloc.dart';
import '../bloc/product_bloc.dart';
import '../widgets/banner_slider_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/product_card_widget.dart';
import '../widgets/section_header_widget.dart';

class HomeApiPage extends StatefulWidget {
  final void Function({String? category})? onSwitchToSearch;
  const HomeApiPage({super.key, this.onSwitchToSearch});

  @override
  State<HomeApiPage> createState() => _HomeApiPageState();
}

class _HomeApiPageState extends State<HomeApiPage> {
  @override
  void initState() {
    super.initState();
    context.read<BannerBloc>().add(const BannerEvent.getBanners());
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    context.read<ProductBloc>().add(const ProductEvent.getProducts());
    context.read<CartBloc>().add(const CartEvent.getCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: BlocBuilder<BannerBloc, BannerState>(
                builder: (context, state) => state.maybeWhen(
                  loaded: (banners) => BannerSliderWidget(banners: banners),
                  loading: () => const SizedBox(
                      height: 170,
                      child: Center(child: CircularProgressIndicator())),
                  orElse: () => const SizedBox(),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) => state.maybeWhen(
                  loaded: (categories) => CategoryWidget(
                    categories: categories,
                    onCategoryTap: (cat) =>
                        widget.onSwitchToSearch?.call(category: cat.slug),
                  ),
                  loading: () => const SizedBox(
                      height: 40,
                      child: Center(child: CircularProgressIndicator())),
                  orElse: () => const SizedBox(),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SectionHeaderWidget(
                title: 'Produk Terbaru',
                onSeeAllTap: () => widget.onSwitchToSearch?.call(),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) => state.maybeWhen(
              loaded: (products, meta) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => ProductCardWidget(
                      product: products[i],
                      onTap: () =>
                          context.push(ProductDetailPage(product: products[i])),
                    ),
                    childCount: products.length,
                  ),
                ),
              ),
              loading: () => const SliverToBoxAdapter(
                child: SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator())),
              ),
              error: (msg) =>
                  SliverToBoxAdapter(child: Center(child: Text(msg))),
              orElse: () => const SliverToBoxAdapter(child: SizedBox()),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 14),
      child: Row(
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(
              text: 'Next',
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.tertiary,
              ),
            ),
            TextSpan(
              text: 'Elektronik',
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ])),
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
}
