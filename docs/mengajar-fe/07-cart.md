# Sesi 07 — Shopping Cart

> ⏱️ Estimasi: 45 menit
> 🎯 Tujuan: Peserta bisa bikin CartBloc (4 event: get/add/update/remove), CartPage dengan item list + qty controls + total price.

---

## 1. Konsep (5 menit)

### Cart = Authenticated Resource
Endpoint cart butuh token. Sebelum call → ambil token dari SharedPreferences → kirim Bearer.

### Optimistic Update
Saat user tap +/- → langsung emit state baru ke UI (instant feedback) → background: panggil API. Kalau API gagal → fetch ulang dari server (rollback).

```dart
// Update UI dulu (optimistic)
emit(CartState.loaded(updatedItems));

// Lalu sync ke server
final result = await datasource.updateCartItem(...);
result.fold(
  (err) async {
    // rollback: fetch ulang dari server
    final cart = await datasource.getCart();
    cart.fold(...);
  },
  (_) async {},  // success: tidak perlu apa-apa
);
```

---

## 2. Cart Models

`lib/data/models/request/cart_request_model.dart`:
```dart
import 'dart:convert';

class CartRequestModel {
  final int productId;
  final int quantity;

  CartRequestModel({required this.productId, required this.quantity});

  Map<String, dynamic> toMap() => {'productId': productId, 'quantity': quantity};
  String toJson() => jsonEncode(toMap());
}
```

`lib/data/models/response/cart_response_model.dart`:
```dart
import 'dart:convert';

import 'package:flutter_onlinestore_app/data/models/response/product_response_model.dart';

class CartResponseModel {
  final bool? success;
  final List<CartItem>? data;

  CartResponseModel({this.success, this.data});

  factory CartResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return CartResponseModel(
      success: map['success'],
      data: map['data'] != null
          ? List<CartItem>.from(map['data'].map((x) => CartItem.fromMap(x)))
          : null,
    );
  }
}

class CartItem {
  final int? id;
  final int? userId;
  final int? productId;
  final int? quantity;
  final String? createdAt;
  final String? updatedAt;
  final Product? product;

  CartItem({
    this.id, this.userId, this.productId, this.quantity,
    this.createdAt, this.updatedAt, this.product,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id']?.toInt(),
      userId: map['userId']?.toInt(),
      productId: map['productId']?.toInt(),
      quantity: map['quantity']?.toInt(),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id, 'userId': userId, 'productId': productId, 'quantity': quantity,
  };
}
```

---

## 3. CartRemoteDatasource

`lib/data/datasources/cart_remote_datasource.dart`:

```dart
import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import '../models/request/cart_request_model.dart';
import '../models/response/cart_response_model.dart';
import 'api_helper.dart';
import 'auth_local_datasource.dart';

class CartRemoteDatasource {
  Future<Either<String, CartResponseModel>> getCart() async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return Right(CartResponseModel.fromJson(response.body));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat keranjang');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> addToCart(CartRequestModel request) async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right('Berhasil ditambahkan ke keranjang');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal menambahkan ke keranjang');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> updateCartItem(int id, int quantity) async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.put(
        Uri.parse('${Variables.baseUrl}/api/cart/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'quantity': quantity}),
      );
      if (response.statusCode == 200) {
        return const Right('Keranjang berhasil diperbarui');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memperbarui keranjang');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> removeCartItem(int id) async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.delete(
        Uri.parse('${Variables.baseUrl}/api/cart/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return const Right('Item berhasil dihapus');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal menghapus item');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
```

---

## 4. CartBloc

### `lib/presentation/cart/bloc/cart_event.dart`
```dart
part of 'cart_bloc.dart';

@freezed
sealed class CartEvent with _$CartEvent {
  const factory CartEvent.getCart() = _GetCart;
  const factory CartEvent.addToCart({
    required int productId,
    @Default(1) int quantity,
  }) = _AddToCart;
  const factory CartEvent.updateCartItem({
    required int id,
    required int quantity,
  }) = _UpdateCartItem;
  const factory CartEvent.removeCartItem(int id) = _RemoveCartItem;
}
```

### `lib/presentation/cart/bloc/cart_state.dart`
```dart
part of 'cart_bloc.dart';

@freezed
sealed class CartState with _$CartState {
  const factory CartState.initial() = _Initial;
  const factory CartState.loading() = _Loading;
  const factory CartState.loaded(List<CartItem> items) = _Loaded;
  const factory CartState.error(String message) = _Error;
}
```

### `lib/presentation/cart/bloc/cart_bloc.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_onlinestore_app/data/datasources/cart_remote_datasource.dart';
import 'package:flutter_onlinestore_app/data/models/request/cart_request_model.dart';
import 'package:flutter_onlinestore_app/data/models/response/cart_response_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_bloc.freezed.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRemoteDatasource _datasource;

  CartBloc(this._datasource) : super(const CartState.initial()) {
    on<_GetCart>(_onGetCart);
    on<_AddToCart>(_onAddToCart);
    on<_UpdateCartItem>(_onUpdateCartItem);
    on<_RemoveCartItem>(_onRemoveCartItem);
  }

  Future<void> _onGetCart(_GetCart event, Emitter<CartState> emit) async {
    emit(const CartState.loading());
    final result = await _datasource.getCart();
    result.fold(
      (err) => emit(CartState.error(err)),
      (data) => emit(CartState.loaded(data.data ?? [])),
    );
  }

  Future<void> _onAddToCart(_AddToCart event, Emitter<CartState> emit) async {
    emit(const CartState.loading());
    final result = await _datasource.addToCart(
      CartRequestModel(productId: event.productId, quantity: event.quantity),
    );
    await result.fold(
      (err) async => emit(CartState.error(err)),
      (_) async {
        // Re-fetch cart untuk dapat list terbaru
        final cartResult = await _datasource.getCart();
        cartResult.fold(
          (err) => emit(CartState.error(err)),
          (data) => emit(CartState.loaded(data.data ?? [])),
        );
      },
    );
  }

  Future<void> _onUpdateCartItem(_UpdateCartItem event, Emitter<CartState> emit) async {
    // Optimistic update: emit dulu
    final currentItems = state is _Loaded ? (state as _Loaded).items : <CartItem>[];
    emit(CartState.loaded(
      currentItems.map((item) {
        if (item.id == event.id) {
          return CartItem(
            id: item.id,
            userId: item.userId,
            productId: item.productId,
            quantity: event.quantity,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
            product: item.product,
          );
        }
        return item;
      }).toList(),
    ));

    // Sync ke server
    final result = await _datasource.updateCartItem(event.id, event.quantity);
    await result.fold(
      (err) async {
        // Rollback: fetch ulang
        final cartResult = await _datasource.getCart();
        cartResult.fold(
          (e) => emit(CartState.error(e)),
          (data) => emit(CartState.loaded(data.data ?? [])),
        );
      },
      (_) async {},
    );
  }

  Future<void> _onRemoveCartItem(_RemoveCartItem event, Emitter<CartState> emit) async {
    // Optimistic remove
    final currentItems = state is _Loaded ? (state as _Loaded).items : <CartItem>[];
    emit(CartState.loaded(
      currentItems.where((item) => item.id != event.id).toList(),
    ));

    final result = await _datasource.removeCartItem(event.id);
    await result.fold(
      (err) async {
        // Rollback
        final cartResult = await _datasource.getCart();
        cartResult.fold(
          (e) => emit(CartState.error(e)),
          (data) => emit(CartState.loaded(data.data ?? [])),
        );
      },
      (_) async {},
    );
  }
}
```

Run build_runner.

---

## 5. CartPage

`lib/presentation/cart/pages/cart_page.dart`:

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/core/extensions/currency_ext.dart';
import 'package:flutter_onlinestore_app/data/models/response/cart_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/cart/bloc/cart_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/checkout/pages/checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const CartEvent.getCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: Text(message)),
            loaded: (items) => items.isEmpty ? _buildEmpty() : _buildList(items),
            orElse: () => const SizedBox(),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (items) => items.isEmpty ? const SizedBox.shrink() : _buildCheckoutBar(items),
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
          Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.grey.withValues(alpha: 0.5)),
          const SpaceHeight(16),
          const Text('Keranjang kamu kosong', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SpaceHeight(8),
          const Text('Yuk mulai belanja!', style: TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }

  Widget _buildList(List<CartItem> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SpaceHeight(12),
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
              width: 72, height: 72,
              child: product?.imageUrl != null && product!.imageUrl.isNotEmpty
                  ? CachedNetworkImage(imageUrl: product.imageUrl, fit: BoxFit.cover)
                  : Container(color: AppColors.slate50, child: const Icon(Icons.image_outlined)),
            ),
          ),
          const SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product?.name ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
                const SpaceHeight(4),
                Text(
                  (product?.price ?? '0').toRupiah,
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
                const SpaceHeight(8),
                Row(
                  children: [
                    _qtyButton(Icons.remove, () {
                      if (qty > 1) {
                        context.read<CartBloc>().add(CartEvent.updateCartItem(
                          id: item.id!, quantity: qty - 1));
                      } else {
                        context.read<CartBloc>().add(CartEvent.removeCartItem(item.id!));
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    _qtyButton(Icons.add, () {
                      context.read<CartBloc>().add(CartEvent.updateCartItem(
                        id: item.id!, quantity: qty + 1));
                    }),
                    const Spacer(),
                    IconButton(
                      onPressed: () => context.read<CartBloc>().add(CartEvent.removeCartItem(item.id!)),
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
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
        width: 28, height: 28,
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
      (sum, item) => sum + ((item.product?.price ?? '0').toPrice * (item.quantity ?? 1)),
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total', style: TextStyle(fontSize: 12, color: AppColors.grey)),
                Text(total.currencyFormatRp, style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
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
```

---

## 6. Register di main.dart

```dart
BlocProvider(create: (_) => CartBloc(CartRemoteDatasource())),
```

---

## 7. Test Flow

1. Tap produk di Home → ProductDetail → "Keranjang"
2. Buka tab Cart (atau dari header icon) → produk muncul
3. Tap "+" → qty bertambah (langsung, optimistic)
4. Tap "-" sampai 1 → tap "-" lagi → item hilang dari list
5. Tap delete icon → item hilang
6. Total update real-time
7. Tap "Checkout" → push CheckoutPage (placeholder)

✅ **Checkpoint**: semua working, total benar.

---

## ✅ Checklist Akhir Sesi 07

- [ ] CartRequestModel + CartResponseModel + CartItem
- [ ] CartRemoteDatasource (get, add, update, remove)
- [ ] CartBloc dengan 4 event handler + optimistic update
- [ ] CartPage dengan list, qty controls, total, checkout bar
- [ ] Empty state untuk cart kosong
- [ ] Total price calculation pakai `.toPrice` extension

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| 401 Unauthorized di cart | Token tidak ke-include | Cek `getToken()` di datasource, pastikan login dulu |
| Total NaN / negatif | Parsing harga salah | Pakai `.toPrice` extension dengan tryParse |
| State stuck di loading setelah update | Lupa emit loaded di akhir | Cek alur emit di handler |
| Item double saat tap rapid | UI tidak sync dengan server | Pakai optimistic update + re-fetch on error |

---

## 📝 Latihan Mandiri

1. Tambah **swipe-to-delete** (Dismissible widget) — alternatif dari tombol delete
2. Tambah **select all checkbox** di header — hitung total dari yang dicheck saja
3. Tambah **shipping estimate preview** di bottom bar (sementara hardcode "Ongkir ~Rp 15.000")
4. Tambah **empty state CTA** button "Mulai Belanja" → pop ke Home

---

## ➡️ Lanjut ke [Sesi 08 — Address & Maps](./08-address-maps.md)
