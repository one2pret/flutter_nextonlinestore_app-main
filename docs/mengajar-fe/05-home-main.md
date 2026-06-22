# Sesi 05 — Main Page & Home

> ⏱️ Estimasi: 75 menit
> 🎯 Tujuan: Peserta bisa bikin MainPage dengan BottomNav (4 tab), Home page dengan banner, kategori chip, dan grid produk, lengkap dengan BLoC untuk fetch data dari backend.

---

## 1. Konsep (10 menit)

### MainPage = Shell BottomNav
Ini "shell" aplikasi setelah login. 4 tab utama:
- **Home** (banner + kategori + produk)
- **Explore/Search** (search & filter)
- **Pesanan** (riwayat order)
- **Profil** (akun user)

### Kenapa `IndexedStack`?
Beda dari `Switch` widget — `IndexedStack` **mempertahankan state tiap tab**. User scroll di Home → pindah ke Search → balik ke Home → scroll position tetap di tempat.

```dart
IndexedStack(
  index: _selectedIndex,
  children: _pages,  // semua page tetap "alive" di memory
)
```

### CustomScrollView & Slivers
Home page gabung banyak komponen (banner horizontal + grid vertikal). Pakai `CustomScrollView` dengan `SliverToBoxAdapter` + `SliverGrid` untuk smooth scroll satu kesatuan (vs `Column + ListView` yang nested-scroll annoying).

---

## 2. Bikin Datasource yang Kurang

### `lib/data/datasources/category_remote_datasource.dart`

```dart
import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:flutter_onlinestore_app/core/constants/variables.dart';
import 'package:flutter_onlinestore_app/data/models/response/product_response_model.dart';
import 'api_helper.dart';

class CategoryRemoteDatasource {
  Future<Either<String, List<Category>>> getCategories() async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = (data['data'] as List)
            .map((x) => Category.fromMap(x))
            .toList();
        return Right(list);
      } else {
        final error = jsonDecode(response.body);
        return Left(error['error'] ?? 'Gagal memuat kategori');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
```

### `lib/data/datasources/banner_remote_datasource.dart`

Buat model dulu di `lib/data/models/response/banner_response_model.dart`:

```dart
class Banner {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? link;
  final int? sortOrder;
  final bool? isActive;

  Banner({this.id, this.title, this.description, this.image, this.link, this.sortOrder, this.isActive});

  factory Banner.fromMap(Map<String, dynamic> map) {
    return Banner(
      id: map['id']?.toInt(),
      title: map['title'],
      description: map['description'],
      image: map['image'],
      link: map['link'],
      sortOrder: map['sortOrder']?.toInt(),
      isActive: map['isActive'],
    );
  }
}
```

Lalu datasource:

```dart
import 'dart:convert';
import 'package:dartz/dartz.dart';

import 'package:flutter_onlinestore_app/core/constants/variables.dart';
import 'package:flutter_onlinestore_app/data/models/response/banner_response_model.dart';
import 'api_helper.dart';

class BannerRemoteDatasource {
  Future<Either<String, List<Banner>>> getBanners() async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/banners'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right((data['data'] as List).map((x) => Banner.fromMap(x)).toList());
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat banner');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
```

### `lib/data/datasources/product_remote_datasource.dart`

```dart
import 'dart:convert';
import 'package:dartz/dartz.dart';

import 'package:flutter_onlinestore_app/core/constants/variables.dart';
import 'package:flutter_onlinestore_app/data/models/response/product_response_model.dart';
import 'api_helper.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts({
    String? category,
    String? search,
    bool? featured,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null) 'category': category,
        if (search != null) 'search': search,
        if (featured != null) 'featured': featured.toString(),
      };

      final uri = Uri.parse('${Variables.baseUrl}/api/products')
          .replace(queryParameters: queryParams);

      final response = await ApiHelper.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return Right(ProductResponseModel.fromJson(response.body));
      } else {
        final error = jsonDecode(response.body);
        return Left(error['error'] ?? 'Gagal memuat produk');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, Product>> getProductDetail(int id) async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(Product.fromMap(data['data']));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Produk tidak ditemukan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
```

---

## 3. BLoCs untuk Home

### 3.1 ProductBloc
Buat 3 file di `lib/presentation/home/bloc/`:

`product_bloc.dart`:
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_onlinestore_app/data/datasources/product_remote_datasource.dart';
import 'package:flutter_onlinestore_app/data/models/response/product_response_model.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource _datasource;

  ProductBloc(this._datasource) : super(const ProductState.initial()) {
    on<_GetProducts>(_onGetProducts);
  }

  Future<void> _onGetProducts(_GetProducts event, Emitter<ProductState> emit) async {
    emit(const ProductState.loading());
    final result = await _datasource.getProducts(
      category: event.category,
      search: event.search,
      featured: event.featured,
      page: event.page,
      limit: event.limit,
    );
    result.fold(
      (err) => emit(ProductState.error(err)),
      (data) => emit(ProductState.loaded(data.data ?? [], data.meta)),
    );
  }
}
```

`product_event.dart`:
```dart
part of 'product_bloc.dart';

@freezed
sealed class ProductEvent with _$ProductEvent {
  const factory ProductEvent.getProducts({
    String? category,
    String? search,
    bool? featured,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _GetProducts;
}
```

`product_state.dart`:
```dart
part of 'product_bloc.dart';

@freezed
sealed class ProductState with _$ProductState {
  const factory ProductState.initial() = _Initial;
  const factory ProductState.loading() = _Loading;
  const factory ProductState.loaded(List<Product> products, PaginationMeta? meta) = _Loaded;
  const factory ProductState.error(String message) = _Error;
}
```

### 3.2 CategoryBloc — Pattern Sama
```dart
// category_bloc.dart
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRemoteDatasource _datasource;
  CategoryBloc(this._datasource) : super(const CategoryState.initial()) {
    on<_GetCategories>((event, emit) async {
      emit(const CategoryState.loading());
      final result = await _datasource.getCategories();
      result.fold(
        (err) => emit(CategoryState.error(err)),
        (data) => emit(CategoryState.loaded(data)),
      );
    });
  }
}

// category_event.dart
@freezed
sealed class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.getCategories() = _GetCategories;
}

// category_state.dart
@freezed
sealed class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = _Initial;
  const factory CategoryState.loading() = _Loading;
  const factory CategoryState.loaded(List<Category> categories) = _Loaded;
  const factory CategoryState.error(String message) = _Error;
}
```

### 3.3 BannerBloc — Pattern Sama
```dart
// banner_bloc.dart
class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRemoteDatasource _datasource;
  BannerBloc(this._datasource) : super(const BannerState.initial()) {
    on<_GetBanners>((event, emit) async {
      emit(const BannerState.loading());
      final result = await _datasource.getBanners();
      result.fold(
        (err) => emit(BannerState.error(err)),
        (data) => emit(BannerState.loaded(data)),
      );
    });
  }
}

// event: getBanners()
// state: initial, loading, loaded(List<Banner>), error(String)
```

Setelah semua tulis → `dart run build_runner build --delete-conflicting-outputs`.

---

## 4. Reusable Widget: ProductCardWidget

Buat `lib/presentation/home/widgets/product_card_widget.dart`:

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/extensions/currency_ext.dart';
import 'package:flutter_onlinestore_app/data/models/response/product_response_model.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCardWidget({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image dengan badge "Unggulan"
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.slate50,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: product.imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const Center(
                                child: SizedBox(width: 24, height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2)),
                              ),
                              errorWidget: (_, __, ___) => const Icon(Icons.image_outlined, size: 48),
                            )
                          : const Icon(Icons.image_outlined, size: 48),
                    ),
                  ),
                  if (product.isFeatured == true)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Unggulan',
                          style: TextStyle(color: AppColors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),

            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? '',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.3),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      (product.price ?? '0').toRupiah,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 13, color: AppColors.warning),
                        const SizedBox(width: 2),
                        const Text('4.8', style: TextStyle(fontSize: 11, color: AppColors.darkGrey)),
                        const SizedBox(width: 4),
                        const Text('·', style: TextStyle(fontSize: 11, color: AppColors.grey)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${product.stock ?? 0}+ terjual',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, color: AppColors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

> 💡 **Key**: `cached_network_image` auto-cache image di local — gambar yang sama tidak download lagi.

---

## 5. Widget: CategoryWidget (Chip Buttons)

Buat `lib/presentation/home/widgets/category_widget.dart`:

```dart
import 'package:flutter/material.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/data/models/response/product_response_model.dart';

class CategoryWidget extends StatelessWidget {
  final List<Category> categories;
  final ValueChanged<Category> onCategoryTap;

  const CategoryWidget({super.key, required this.categories, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => onCategoryTap(category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  category.name ?? '',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 6. Widget: BannerSliderWidget

Buat `lib/presentation/home/widgets/banner_slider_widget.dart`:

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/data/models/response/banner_response_model.dart';

class BannerSliderWidget extends StatefulWidget {
  final List<Banner> banners;
  const BannerSliderWidget({super.key, required this.banners});

  @override
  State<BannerSliderWidget> createState() => _BannerSliderWidgetState();
}

class _BannerSliderWidgetState extends State<BannerSliderWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox();

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160,
            viewportFraction: 0.92,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            onPageChanged: (i, _) => setState(() => _current = i),
          ),
          items: widget.banners.map((b) => ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: b.image ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          )).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.banners.asMap().entries.map((entry) {
            final active = entry.key == _current;
            return Container(
              width: active ? 16 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
```

---

## 7. Widget: SectionHeaderWidget

Buat `lib/presentation/home/widgets/section_header_widget.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_onlinestore_app/core/constants/colors.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAllTap;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                ],
              ],
            ),
          ),
          if (onSeeAllTap != null)
            GestureDetector(
              onTap: onSeeAllTap,
              child: const Text(
                'Lihat Semua >',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary),
              ),
            ),
        ],
      ),
    );
  }
}
```

---

## 8. HomePage (Disederhanakan)

> 📝 **Versi simplified** — versi lengkap di repo includes geolocator detection, lihat repo akhir. Untuk sesi pertama, fokus pada banner + kategori + grid produk dulu.

Buat `lib/presentation/home/pages/home_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/presentation/home/bloc/banner_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/home/bloc/category_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/home/bloc/product_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/home/widgets/banner_slider_widget.dart';
import 'package:flutter_onlinestore_app/presentation/home/widgets/category_widget.dart';
import 'package:flutter_onlinestore_app/presentation/home/widgets/product_card_widget.dart';
import 'package:flutter_onlinestore_app/presentation/home/widgets/section_header_widget.dart';
import 'package:flutter_onlinestore_app/presentation/product/pages/product_detail_page.dart';

class HomePage extends StatefulWidget {
  final void Function({String? category})? onSwitchToSearch;
  const HomePage({super.key, this.onSwitchToSearch});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch semua data sekaligus
    context.read<BannerBloc>().add(const BannerEvent.getBanners());
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    context.read<ProductBloc>().add(const ProductEvent.getProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          // Teal header
          SliverToBoxAdapter(child: _buildHeader(context)),

          // Banner Slider
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: BlocBuilder<BannerBloc, BannerState>(
                builder: (context, state) => state.maybeWhen(
                  loaded: (banners) => BannerSliderWidget(banners: banners),
                  loading: () => const SizedBox(height: 170, child: Center(child: CircularProgressIndicator())),
                  orElse: () => const SizedBox(),
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) => state.maybeWhen(
                  loaded: (categories) => CategoryWidget(
                    categories: categories,
                    onCategoryTap: (cat) => widget.onSwitchToSearch?.call(category: cat.slug),
                  ),
                  loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
                  orElse: () => const SizedBox(),
                ),
              ),
            ),
          ),

          // Section header
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

          // Products grid
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) => state.maybeWhen(
              loaded: (products, meta) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => ProductCardWidget(
                      product: products[i],
                      onTap: () => context.push(ProductDetailPage(product: products[i])),
                    ),
                    childCount: products.length,
                  ),
                ),
              ),
              loading: () => const SliverToBoxAdapter(
                child: SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
              ),
              error: (msg) => SliverToBoxAdapter(child: Center(child: Text(msg))),
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
      child: Column(
        children: [
          Row(
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(text: 'Next', style: GoogleFonts.quicksand(
                  fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                TextSpan(text: 'Elektronik', style: GoogleFonts.quicksand(
                  fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.white)),
              ])),
              const Spacer(),
              // Cart icon dengan badge — diisi nanti di sesi 07
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## 9. SearchPage (Placeholder)

Buat `lib/presentation/home/pages/search_page.dart` — sederhana dulu, full implementation nanti di sesi 06:

```dart
import 'package:flutter/material.dart';
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Search Page')));
}
```

---

## 10. MainPage (BottomNav)

Buat `lib/presentation/home/pages/main_page.dart`:

```dart
import 'package:flutter/material.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/presentation/home/pages/home_page.dart';
import 'package:flutter_onlinestore_app/presentation/home/pages/search_page.dart';
import 'package:flutter_onlinestore_app/presentation/order/pages/order_list_page.dart';
import 'package:flutter_onlinestore_app/presentation/profile/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _switchToSearch({String? category}) {
    setState(() => _selectedIndex = 1);
  }

  List<Widget> get _pages => [
    HomePage(onSwitchToSearch: _switchToSearch),
    const SearchPage(),
    const OrderListPage(),       // placeholder sementara
    const ProfilePage(),          // placeholder sementara
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white.withValues(alpha: 0.6),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Pesanan'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
```

> ⚠️ **Catatan**: `OrderListPage` & `ProfilePage` belum ada — bikin placeholder dulu:
> ```dart
> // lib/presentation/order/pages/order_list_page.dart
> import 'package:flutter/material.dart';
> class OrderListPage extends StatelessWidget {
>   const OrderListPage({super.key});
>   @override
>   Widget build(BuildContext context) =>
>       const Scaffold(body: Center(child: Text('Pesanan')));
> }
> ```
> Sama untuk `ProfilePage`.

---

## 11. Register Bloc di main.dart

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => LoginBloc(AuthRemoteDatasource())),
    BlocProvider(create: (_) => RegisterBloc(AuthRemoteDatasource())),
    BlocProvider(create: (_) => ProductBloc(ProductRemoteDatasource())),
    BlocProvider(create: (_) => CategoryBloc(CategoryRemoteDatasource())),
    BlocProvider(create: (_) => BannerBloc(BannerRemoteDatasource())),
  ],
  child: MaterialApp(...),
)
```

Jangan lupa import datasource & bloc baru.

---

## 12. Test Run

1. Login → MainPage muncul
2. Tab Home: banner slider auto-play, kategori chip horizontal, grid produk 2 kolom
3. Scroll smooth dari banner sampai produk paling bawah
4. Tap tab Explore/Pesanan/Profil → page lain (placeholder)
5. Balik tab Home → state tetap (scroll position di tempat)

✅ **Checkpoint**: semua fetch sukses dan tampil di home.

---

## ✅ Checklist Akhir Sesi 05

- [ ] 3 Bloc baru: ProductBloc, CategoryBloc, BannerBloc (+ freezed generated)
- [ ] 3 datasource baru: CategoryRemoteDatasource, BannerRemoteDatasource, ProductRemoteDatasource
- [ ] 4 widget: ProductCardWidget, CategoryWidget, BannerSliderWidget, SectionHeaderWidget
- [ ] HomePage dengan CustomScrollView + Sliver
- [ ] MainPage dengan BottomNav + IndexedStack
- [ ] main.dart updated dengan provider baru
- [ ] Login → Home → banner & produk muncul

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| `RenderBox was not laid out` | Nest ListView inside Column tanpa constraint | Pakai SizedBox(height: X) atau Sliver di CustomScrollView |
| Banner slider tidak muncul | carousel_slider versi salah | Pastikan ^5.0.0 dan import `package:carousel_slider/carousel_slider.dart` |
| Image produk blank | URL salah atau internet putus | Cek `product.imageUrl`, tambah errorWidget |
| `BlocProvider.of() called with a context that does not contain a Bloc` | Lupa register di MultiBlocProvider | Tambah BlocProvider di main.dart |
| State tab hilang saat pindah tab | Pakai `Switch` widget, bukan `IndexedStack` | Ganti ke `IndexedStack` |

---

## 📝 Latihan Mandiri

1. Tambah **pull-to-refresh** di HomePage (`RefreshIndicator`) → trigger ulang `getBanners()`, `getCategories()`, `getProducts()`
2. Tambah **shimmer loading** (package `shimmer`) untuk product grid saat loading (replace CircularProgressIndicator)
3. Tambah **featured products** section (horizontal list) di atas product grid — fetch dengan `featured: true`
4. Tambah icon **notification** (bell) di header — sementara tap → SnackBar "Belum ada notifikasi"

---

## ➡️ Lanjut ke [Sesi 06 — Product Detail](./06-product-detail.md)
