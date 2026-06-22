# Sesi 06 — Product Detail Page

> ⏱️ Estimasi: 45 menit
> 🎯 Tujuan: Peserta bisa bikin halaman detail produk lengkap dengan gambar, deskripsi, harga, dan dua tombol bottom bar (Keranjang + Beli Sekarang).

---

## 1. Konsep (5 menit)

### Pattern Detail Page
- Page menerima **model parsial** (`Product` dari list) → tampil instant
- Lalu **fetch detail lengkap** dari API → update UI saat detail datang
- Pakai `late Product _product` untuk reassign saat detail datang

### Why fetch ulang?
List API kadang return field minimal (id, name, image, price). Detail API return semua field (description, weight, stock, dll).

---

## 2. ProductDetailBloc (Optional)

Karena detail page langsung fetch lewat datasource, BLoC opsional. Pattern di repo: BLoC `ProductDetailBloc` exists tapi page pakai panggilan langsung. Tetap buat untuk konsistensi.

`lib/presentation/product/bloc/product_detail_bloc.dart`:
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_onlinestore_app/data/datasources/product_remote_datasource.dart';
import 'package:flutter_onlinestore_app/data/models/response/product_response_model.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';
part 'product_detail_bloc.freezed.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRemoteDatasource _datasource;

  ProductDetailBloc(this._datasource) : super(const ProductDetailState.initial()) {
    on<_GetProductDetail>((event, emit) async {
      emit(const ProductDetailState.loading());
      final result = await _datasource.getProductDetail(event.id);
      result.fold(
        (err) => emit(ProductDetailState.error(err)),
        (data) => emit(ProductDetailState.loaded(data)),
      );
    });
  }
}
```

Event & state seperti pattern sebelumnya:
```dart
// event
@freezed
sealed class ProductDetailEvent with _$ProductDetailEvent {
  const factory ProductDetailEvent.getProductDetail(int id) = _GetProductDetail;
}

// state
@freezed
sealed class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState.initial() = _Initial;
  const factory ProductDetailState.loading() = _Loading;
  const factory ProductDetailState.loaded(Product product) = _Loaded;
  const factory ProductDetailState.error(String message) = _Error;
}
```

---

## 3. ProductDetailPage

Buat `lib/presentation/product/pages/product_detail_page.dart`:

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/extensions/currency_ext.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/data/datasources/product_remote_datasource.dart';
import 'package:flutter_onlinestore_app/data/models/response/product_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/cart/bloc/cart_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/cart/pages/cart_page.dart';
import 'package:flutter_onlinestore_app/presentation/checkout/pages/checkout_page.dart';

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
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    if (_product.id == null) return;
    final result = await ProductRemoteDatasource().getProductDetail(_product.id!);
    if (!mounted) return;
    result.fold((_) {}, (data) => setState(() => _product = data));
  }

  void _addToCart() {
    if (_product.id == null) return;
    _isAddingToCart = true;
    context.read<CartBloc>().add(CartEvent.addToCart(productId: _product.id!));
  }

  void _buyNow() {
    if (_product.id == null) return;
    _isAddingToCart = true;
    _isBuyNow = true;
    context.read<CartBloc>().add(CartEvent.addToCart(productId: _product.id!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
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
              content: Text('${_product.name} ditambahkan ke keranjang'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ));
          },
          error: (message) {
            _isAddingToCart = false;
            _isBuyNow = false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
            ));
          },
          orElse: () {},
        );
      },
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
          const Expanded(child: SizedBox()),
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
                    icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.white),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 4, top: 4,
                      child: Container(
                        width: 16, height: 16,
                        decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                        child: Center(child: Text('$count', style: const TextStyle(
                          color: AppColors.white, fontSize: 9, fontWeight: FontWeight.bold))),
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
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.image_outlined, size: 120, color: AppColors.grey),
            )
          : const Icon(Icons.image_outlined, size: 120, color: AppColors.grey),
    );
  }

  Widget _buildPrice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        (_product.price ?? '0').toRupiah,
        style: GoogleFonts.quicksand(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_product.name ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4)),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              const Icon(Icons.star_rounded, size: 15, color: AppColors.warning),
              const Text('4.9', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text('· ${_product.stock ?? 0}+ terjual',
                  style: const TextStyle(fontSize: 12, color: AppColors.grey)),
              if (_product.isFeatured == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Unggulan', style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
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
          const Text('Deskripsi Produk', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            _product.description ?? 'Tidak ada deskripsi.',
            style: const TextStyle(fontSize: 13, color: AppColors.darkGrey, height: 1.6),
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
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.grey))),
          Text(': $value', style: const TextStyle(fontSize: 13, color: AppColors.darkGrey)),
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
        boxShadow: [BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: outOfStock
            ? SizedBox(
                width: double.infinity, height: 46,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.grey),
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
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
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
```

---

## 4. Penjelasan Penting

### A. `late Product _product` + Reassign
Pattern ini bikin UI responsive: tampil dulu data dari list, lalu update setelah detail datang.

```dart
late Product _product;       // assigned di initState
_product = widget.product;   // initial value

// async fetch detail
final result = await ProductRemoteDatasource().getProductDetail(_product.id!);
result.fold((_) {}, (data) => setState(() => _product = data));
```

### B. `_isAddingToCart` Flag
Karena CartBloc dipakai berbagai page, kita perlu tau apakah event sukses ini DARI page ini atau bukan. Pakai flag boolean lokal.

```dart
void _addToCart() {
  _isAddingToCart = true;     // mark "saya yang trigger"
  context.read<CartBloc>().add(...);
}

// di BlocListener
loaded: (_) {
  if (!_isAddingToCart) return;   // bukan dari saya, skip
  _isAddingToCart = false;
  // show snackbar
}
```

### C. "Beli Sekarang" Pattern
1. Add to cart dulu (via event)
2. Set `_isBuyNow = true`
3. Saat CartBloc loaded → push CheckoutPage

### D. Cart Badge di Header
```dart
BlocBuilder<CartBloc, CartState>(
  builder: (context, state) {
    final count = state.maybeWhen(
      loaded: (items) => items.length,
      orElse: () => 0,
    );
    return Stack(children: [
      IconButton(...),
      if (count > 0) Positioned(...badge...),
    ]);
  },
)
```

---

## 5. Register Bloc di main.dart

```dart
BlocProvider(create: (_) => ProductDetailBloc(ProductRemoteDatasource())),
```

---

## 6. Test Flow

1. Home → tap salah satu produk → ProductDetailPage muncul
2. Gambar tampil, harga & nama produk muncul
3. Tap "Keranjang" → SnackBar "Ditambahkan ke keranjang"
4. Badge cart di header bertambah +1
5. Tap "Beli Sekarang" → langsung pindah ke CheckoutPage (placeholder dulu)

✅ **Checkpoint**: SnackBar muncul + badge cart update.

> ⚠️ **Catatan**: CheckoutPage & CartPage & CartBloc belum dibuat. Bikin placeholder sementara untuk test:
> ```dart
> // CartPage placeholder
> class CartPage extends StatelessWidget {
>   const CartPage({super.key});
>   @override
>   Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Cart')));
> }
> 
> // CheckoutPage placeholder — sama
> ```

---

## ✅ Checklist Akhir Sesi 06

- [ ] ProductDetailBloc + Event + State + freezed
- [ ] ProductDetailPage dengan CustomScrollView
- [ ] Bottom bar 2 tombol (Keranjang + Beli Sekarang)
- [ ] Handle out-of-stock state (disabled button)
- [ ] BlocListener untuk CartBloc → SnackBar / navigate
- [ ] Header dengan back button + cart badge
- [ ] Test: tap produk dari Home → detail muncul

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| `LateInitializationError: _product` | Akses _product sebelum initState | Pastikan `_product = widget.product` di awal initState |
| `Null check operator used on null value` | `_product.id!` tapi null | Cek dulu `if (_product.id == null) return;` |
| Badge cart tidak update | Lupa fetch cart saat initial | Trigger `CartBloc.add(CartEvent.getCart())` saat app start |
| SnackBar muncul 2x | Listener trigger berkali-kali | Pakai flag `_isAddingToCart` untuk filter |

---

## 📝 Latihan Mandiri

1. Tambah **gambar carousel** (multiple images) — kalau API support `images: List<String>`
2. Tambah **section "Produk Terkait"** di bawah deskripsi (fetch by same category)
3. Tambah tombol **favorite/wishlist** di pojok kanan atas image (toggle local state)
4. Tampilkan badge **"Diskon X%"** kalau ada `discountPercent` di product model

---

## ➡️ Lanjut ke [Sesi 07 — Shopping Cart](./07-cart.md)
