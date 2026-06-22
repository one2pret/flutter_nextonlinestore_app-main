# Sesi 10 — Payment WebView & Orders

> ⏱️ Estimasi: 75 menit
> 🎯 Tujuan: Peserta paham integrasi WebView untuk payment Xendit, deteksi redirect URL setelah bayar, dan bikin OrderList + OrderDetail lengkap dengan cancel + repay + tracking.

---

## 1. Konsep (10 menit)

### Kenapa WebView untuk Payment?
Xendit invoice = halaman web yang aman & PCI-compliant. JANGAN bikin form payment sendiri di Flutter (regulasi + security).

Flow:
```
POST /api/orders → backend bikin invoice di Xendit → return invoiceUrl
   ↓
Flutter buka invoiceUrl di WebView
   ↓
User bayar (QRIS / VA / e-wallet) di WebView
   ↓
Xendit redirect ke success URL (configured di backend)
   ↓
Flutter detect URL redirect → tutup WebView → PaymentSuccessPage
```

### Order Status Machine (sync backend)
- `waiting_payment` → user belum bayar
- `packing` → sudah bayar, dikemas admin
- `shipping` → kurir pick up
- `delivered` → sampai
- `expired` → tidak bayar dalam 24 jam
- `cancelled` → dibatalkan

### Cancel & Repay
- **Cancel**: hanya bisa di status `waiting_payment` / `packing` (sebelum shipping)
- **Repay**: hanya untuk order `expired` — backend bikin invoice baru, return URL baru

---

## 2. Order Models

`lib/data/models/response/order_response_model.dart` (extract penting):

```dart
import 'dart:convert';

class OrderResponseModel {
  final bool? success;
  final List<Order>? data;
  OrderResponseModel({this.success, this.data});

  factory OrderResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return OrderResponseModel(
      success: map['success'],
      data: map['data'] != null
          ? List<Order>.from(map['data'].map((x) => Order.fromMap(x)))
          : null,
    );
  }
}

class OrderDetailResponseModel {
  final bool? success;
  final Order? data;
  final String? paymentUrl;

  OrderDetailResponseModel({this.success, this.data, this.paymentUrl});

  factory OrderDetailResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return OrderDetailResponseModel(
      success: map['success'],
      data: map['data'] != null ? Order.fromMap(map['data']) : null,
      paymentUrl: map['data']?['paymentUrl'],
    );
  }
}

class Order {
  final int? id;
  final String? orderNumber;
  final String? status;
  final String? subtotal;
  final String? shippingCost;
  final String? total;
  final String? shippingName;
  final String? shippingAddress;
  final String? willExpiredAt;
  final String? createdAt;
  final List<OrderItem>? items;
  final OrderShipping? shipping;
  final String? paymentUrl;

  Order({
    this.id, this.orderNumber, this.status, this.subtotal, this.shippingCost,
    this.total, this.shippingName, this.shippingAddress, this.willExpiredAt,
    this.createdAt, this.items, this.shipping, this.paymentUrl,
  });

  factory Order.fromMap(Map<String, dynamic> map) => Order(
    id: map['id']?.toInt(),
    orderNumber: map['orderNumber'],
    status: map['status'],
    subtotal: map['subtotal']?.toString(),
    shippingCost: map['shippingCost']?.toString(),
    total: map['total']?.toString(),
    shippingName: map['shippingName'],
    shippingAddress: map['shippingAddress'],
    willExpiredAt: map['willExpiredAt'],
    createdAt: map['createdAt'],
    items: map['items'] != null
        ? List<OrderItem>.from(map['items'].map((x) => OrderItem.fromMap(x)))
        : null,
    shipping: map['shipping'] != null ? OrderShipping.fromMap(map['shipping']) : null,
    paymentUrl: map['paymentUrl'],
  );

  String get statusLabel => switch (status) {
    'waiting_payment' => 'Menunggu Pembayaran',
    'packing' => 'Diproses',
    'shipping' => 'Dikirim',
    'delivered' => 'Selesai',
    'cancelled' => 'Dibatalkan',
    'expired' => 'Kadaluarsa',
    _ => status ?? '',
  };

  int get totalItemCount => items?.fold(0, (sum, i) => sum! + (i.quantity ?? 0)) ?? 0;
}

class OrderItem {
  final int? id;
  final String? productName;
  final String? productImage;
  final String? price;
  final int? quantity;
  final String? subtotal;

  OrderItem({this.id, this.productName, this.productImage, this.price, this.quantity, this.subtotal});

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
    id: map['id']?.toInt(),
    productName: map['productName'],
    productImage: map['productImage'],
    price: map['price']?.toString(),
    quantity: map['quantity']?.toInt(),
    subtotal: map['subtotal']?.toString(),
  );
}

class OrderShipping {
  final String? courierName;
  final String? trackingId;
  final String? waybillId;
  final List<ShippingHistory>? histories;

  OrderShipping({this.courierName, this.trackingId, this.waybillId, this.histories});

  factory OrderShipping.fromMap(Map<String, dynamic> map) => OrderShipping(
    courierName: map['courierName'],
    trackingId: map['trackingId'],
    waybillId: map['waybillId'],
    histories: map['histories'] != null
        ? List<ShippingHistory>.from(map['histories'].map((x) => ShippingHistory.fromMap(x)))
        : null,
  );
}

class ShippingHistory {
  final String? status;
  final String? note;
  final String? createdAt;

  ShippingHistory({this.status, this.note, this.createdAt});

  factory ShippingHistory.fromMap(Map<String, dynamic> map) => ShippingHistory(
    status: map['status'],
    note: map['note'],
    createdAt: map['createdAt'],
  );
}
```

> 💡 `paymentUrl` di-flatten ke top-level `Order` & juga ke `OrderDetailResponseModel` karena backend kadang ngirim di salah satu tempat.

---

## 3. OrderRemoteDatasource

`lib/data/datasources/order_remote_datasource.dart`:

```dart
import 'dart:convert';
import 'package:dartz/dartz.dart' hide Order;

import '../../core/constants/variables.dart';
import '../models/request/order_request_model.dart';
import '../models/response/order_response_model.dart';
import 'api_helper.dart';
import 'auth_local_datasource.dart';

class OrderRemoteDatasource {
  Future<Map<String, String>> _authHeaders() async {
    final token = await AuthLocalDatasource().getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Either<String, OrderResponseModel>> getOrders({
    String? status, int page = 1, int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
      };
      final uri = Uri.parse('${Variables.baseUrl}/api/orders')
          .replace(queryParameters: queryParams);
      final response = await ApiHelper.get(uri, headers: await _authHeaders());
      if (response.statusCode == 200) {
        return Right(OrderResponseModel.fromJson(response.body));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat pesanan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, OrderDetailResponseModel>> createOrder(OrderRequestModel request) async {
    try {
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/orders'),
        headers: await _authHeaders(),
        body: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(OrderDetailResponseModel.fromJson(response.body));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal membuat pesanan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, Order>> getOrderDetail(int id) async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/orders/$id'),
        headers: await _authHeaders(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(Order.fromMap(data['data']));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Pesanan tidak ditemukan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> cancelOrder(int id, {String? reason}) async {
    try {
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/orders/$id/cancel'),
        headers: await _authHeaders(),
        body: jsonEncode({if (reason != null && reason.isNotEmpty) 'reason': reason}),
      );
      if (response.statusCode == 200) return const Right('Pesanan berhasil dibatalkan');
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal membatalkan pesanan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> repayOrder(int id) async {
    try {
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/orders/$id/repay'),
        headers: await _authHeaders(),
        body: jsonEncode({}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(data['data']?['paymentUrl'] ?? '');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal membuat ulang pembayaran');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, OrderShipping>> getTracking(int id) async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/orders/$id/tracking'),
        headers: await _authHeaders(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(OrderShipping.fromMap(data['data']));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat tracking');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
```

---

## 4. PaymentPage (WebView)

`lib/presentation/checkout/pages/payment_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/constants/variables.dart';
import 'package:flutter_onlinestore_app/data/models/response/order_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/checkout/pages/payment_success_page.dart';
import 'package:flutter_onlinestore_app/presentation/order/pages/order_detail_page.dart';

class PaymentPage extends StatefulWidget {
  final String paymentUrl;
  final Order order;
  const PaymentPage({super.key, required this.paymentUrl, required this.order});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: _onNavRequest,
        onPageStarted: (_) => setState(() => _isLoading = true),
        onProgress: (p) => setState(() => _loadingProgress = p),
        onPageFinished: (_) => setState(() => _isLoading = false),
      ))
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  NavigationDecision _onNavRequest(NavigationRequest request) {
    // Backend redirect ke /orders/<id> setelah payment success
    final redirectBase = '${Variables.baseUrl}/orders/';
    if (request.url.startsWith(redirectBase)) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => PaymentSuccessPage(order: widget.order),
      ));
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<bool> _confirmExit() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tinggalkan Pembayaran?'),
        content: const Text('Anda masih bisa bayar nanti dari detail pesanan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Lanjut Bayar')),
          TextButton(onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (shouldLeave == true && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => OrderDetailPage(orderId: widget.order.id!),
      ));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran', style: TextStyle(color: AppColors.white)),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          leading: IconButton(icon: const Icon(Icons.close), onPressed: _confirmExit),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              LinearProgressIndicator(
                value: _loadingProgress / 100,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
          ],
        ),
      ),
    );
  }
}
```

### Penjelasan Key:
- **`PopScope`**: prevent back button accidental → konfirmasi dulu
- **`onNavigationRequest`**: dipanggil tiap kali WebView navigate ke URL baru. Detect kapan Xendit redirect ke success URL → tutup WebView
- **`onProgress`**: untuk progress bar di atas WebView (UX nice-to-have)

---

## 5. PaymentSuccessPage

`lib/presentation/checkout/pages/payment_success_page.dart`:

```dart
import 'package:flutter/material.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/data/models/response/order_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/home/pages/main_page.dart';
import 'package:flutter_onlinestore_app/presentation/order/pages/order_detail_page.dart';

class PaymentSuccessPage extends StatelessWidget {
  final Order order;
  const PaymentSuccessPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120, height: 120,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 64, color: AppColors.white),
              ),
              const SpaceHeight(24),
              const Text('Pembayaran Berhasil!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SpaceHeight(8),
              Text('Order #${order.orderNumber ?? '-'}'),
              const SpaceHeight(8),
              const Text('Pesanan kamu sudah masuk antrian pengemasan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.darkGrey)),
              const Spacer(),
              Button.filled(
                onPressed: () => context.push(OrderDetailPage(orderId: order.id!)),
                label: 'Lihat Pesanan',
                width: double.infinity,
              ),
              const SpaceHeight(12),
              Button.outlined(
                onPressed: () => context.pushAndRemoveUntil(const MainPage()),
                label: 'Kembali ke Home',
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 6. OrderBloc

```dart
@freezed
sealed class OrderEvent with _$OrderEvent {
  const factory OrderEvent.getOrders({String? status}) = _GetOrders;
  const factory OrderEvent.getOrderDetail(int id) = _GetOrderDetail;
  const factory OrderEvent.cancelOrder(int id, {String? reason}) = _CancelOrder;
  const factory OrderEvent.repayOrder(int id) = _RepayOrder;
}

@freezed
sealed class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
  const factory OrderState.listLoaded(List<Order> orders) = _ListLoaded;
  const factory OrderState.detailLoaded(Order order) = _DetailLoaded;
  const factory OrderState.actionSuccess(String message, {String? paymentUrl}) = _ActionSuccess;
  const factory OrderState.error(String message) = _Error;
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRemoteDatasource _datasource;
  OrderBloc(this._datasource) : super(const OrderState.initial()) {
    on<_GetOrders>((event, emit) async {
      emit(const OrderState.loading());
      final result = await _datasource.getOrders(status: event.status);
      result.fold(
        (err) => emit(OrderState.error(err)),
        (data) => emit(OrderState.listLoaded(data.data ?? [])),
      );
    });

    on<_GetOrderDetail>((event, emit) async {
      emit(const OrderState.loading());
      final result = await _datasource.getOrderDetail(event.id);
      result.fold(
        (err) => emit(OrderState.error(err)),
        (data) => emit(OrderState.detailLoaded(data)),
      );
    });

    on<_CancelOrder>((event, emit) async {
      final result = await _datasource.cancelOrder(event.id, reason: event.reason);
      result.fold(
        (err) => emit(OrderState.error(err)),
        (msg) => emit(OrderState.actionSuccess(msg)),
      );
    });

    on<_RepayOrder>((event, emit) async {
      final result = await _datasource.repayOrder(event.id);
      result.fold(
        (err) => emit(OrderState.error(err)),
        (url) => emit(OrderState.actionSuccess('Membuka ulang pembayaran', paymentUrl: url)),
      );
    });
  }
}
```

---

## 7. OrderListPage

`lib/presentation/order/pages/order_list_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/core/extensions/currency_ext.dart';
import 'package:flutter_onlinestore_app/data/models/response/order_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/order/bloc/order_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/order/pages/order_detail_page.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const OrderEvent.getOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Saya'), automaticallyImplyLeading: false),
      body: RefreshIndicator(
        onRefresh: () async => context.read<OrderBloc>().add(const OrderEvent.getOrders()),
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) => state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            listLoaded: (list) => list.isEmpty
                ? const Center(child: Text('Belum ada pesanan'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
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
              Expanded(child: Text(o.orderNumber ?? '-', style: const TextStyle(fontWeight: FontWeight.bold))),
              _statusBadge(o.status, o.statusLabel),
            ]),
            const SizedBox(height: 8),
            Text('${o.totalItemCount} item · ${(o.total ?? '0').toRupiah}',
              style: const TextStyle(color: AppColors.darkGrey)),
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
      child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
```

---

## 8. OrderDetailPage

`lib/presentation/order/pages/order_detail_page.dart`:

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/core/extensions/currency_ext.dart';
import 'package:flutter_onlinestore_app/core/extensions/date_ext.dart';
import 'package:flutter_onlinestore_app/data/models/response/order_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/checkout/pages/payment_page.dart';
import 'package:flutter_onlinestore_app/presentation/order/bloc/order_bloc.dart';

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
    context.read<OrderBloc>().add(OrderEvent.getOrderDetail(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          state.maybeWhen(
            actionSuccess: (msg, paymentUrl) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
              if (paymentUrl != null && paymentUrl.isNotEmpty) {
                // Refetch detail dulu untuk dapat Order object
                context.read<OrderBloc>().add(OrderEvent.getOrderDetail(widget.orderId));
              } else {
                // Refresh detail
                context.read<OrderBloc>().add(OrderEvent.getOrderDetail(widget.orderId));
              }
            },
            error: (msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg))),
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
          // Status header
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
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.statusLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    Text(o.orderNumber ?? '', style: const TextStyle(fontSize: 12)),
                  ],
                )),
              ],
            ),
          ),
          const SpaceHeight(16),

          // Items
          _section('Item Pesanan', Column(
            children: (o.items ?? []).map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                if (item.productImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 50, height: 50,
                      child: CachedNetworkImage(imageUrl: item.productImage!, fit: BoxFit.cover),
                    ),
                  ),
                const SpaceWidth(8),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text('${item.quantity}x · ${(item.price ?? '0').toRupiah}',
                      style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                  ],
                )),
                Text((item.subtotal ?? '0').toRupiah,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            )).toList(),
          )),

          // Shipping
          _section('Alamat Pengiriman', Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(o.shippingName ?? '-'),
              Text(o.shippingAddress ?? '-'),
            ],
          )),

          // Tracking
          if (o.shipping != null) _section('Tracking', _buildTracking(o.shipping!)),

          // Summary
          _section('Ringkasan', Column(
            children: [
              _row('Subtotal', (o.subtotal ?? '0').toRupiah),
              _row('Ongkir', (o.shippingCost ?? '0').toRupiah),
              const Divider(),
              _row('Total', (o.total ?? '0').toRupiah, bold: true),
            ],
          )),

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
          const Text('Belum ada history', style: TextStyle(color: AppColors.grey))
        else
          ...histories.map((h) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.circle, size: 8, color: AppColors.primary),
              const SpaceWidth(8),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h.note ?? h.status ?? ''),
                  if (h.createdAt != null)
                    Text(h.createdAt!.toFormattedDate,
                      style: const TextStyle(fontSize: 11, color: AppColors.grey)),
                ],
              )),
            ]),
          )),
      ],
    );
  }

  Widget _buildActionButtons(Order o) {
    final canCancel = o.status == 'waiting_payment' || o.status == 'packing';
    final canRepay = o.status == 'expired';
    final canPayNow = o.status == 'waiting_payment' && (o.paymentUrl?.isNotEmpty == true);

    return Column(children: [
      if (canPayNow) Button.filled(
        onPressed: () => context.push(PaymentPage(paymentUrl: o.paymentUrl!, order: o)),
        label: 'Bayar Sekarang',
        width: double.infinity,
      ),
      if (canRepay) Button.filled(
        onPressed: () => context.read<OrderBloc>().add(OrderEvent.repayOrder(o.id!)),
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
        content: const Text('Pesanan akan dibatalkan dan tidak bisa dipulihkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tidak')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<OrderBloc>().add(OrderEvent.cancelOrder(id));
            },
            child: const Text('Ya, Batalkan', style: TextStyle(color: AppColors.error)),
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
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SpaceHeight(8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
    ]),
  );
}
```

---

## 9. Update CheckoutPage agar Push PaymentPage dengan Order

Pastikan signature PaymentPage dipakai konsisten — terima `Order order` + `String paymentUrl`. Update di CheckoutPage:

```dart
state.maybeWhen(
  success: (order, paymentUrl) {
    if (paymentUrl != null && paymentUrl.isNotEmpty) {
      context.pushReplacement(PaymentPage(paymentUrl: paymentUrl, order: order));
    }
  },
  ...
);
```

---

## 10. Register di main.dart

```dart
BlocProvider(create: (_) => OrderBloc(OrderRemoteDatasource())),
```

---

## 11. Test Flow Lengkap

1. CheckoutPage → tap "Bayar" → PaymentPage WebView terbuka
2. UI Xendit invoice muncul, pilih VA/QRIS test
3. Bayar pakai mode test (Xendit dashboard menyediakan test number)
4. Setelah sukses → backend redirect ke `/orders/{id}` → WebView detect → PaymentSuccessPage
5. Tap "Lihat Pesanan" → OrderDetailPage
6. Status `packing`, tampil items, tracking placeholder
7. Tab "Pesanan" di bottom nav → list orders muncul, tap order → detail
8. Order expired? → tombol "Bayar Ulang" → repay → URL baru → PaymentPage
9. Order `waiting_payment` atau `packing` → tombol "Batalkan" muncul

✅ **Checkpoint**: Payment WebView berfungsi, redirect terdeteksi, cancel & repay working.

---

## ✅ Checklist Akhir Sesi 10

- [ ] Order models (response + Invoice + OrderShipping + ShippingHistory)
- [ ] OrderRemoteDatasource (get list, get detail, create, cancel, repay, tracking)
- [ ] PaymentPage dengan WebView + redirect detection
- [ ] PaymentSuccessPage
- [ ] OrderBloc + freezed
- [ ] OrderListPage dengan pull-to-refresh + status badge
- [ ] OrderDetailPage dengan items, tracking, summary, action buttons
- [ ] Cancel order dengan konfirmasi dialog
- [ ] Repay order: URL baru → WebView
- [ ] Test end-to-end: checkout → bayar → success → detail

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| WebView blank | URL salah / SSL invalid | Cek paymentUrl di debug log |
| Redirect tidak terdeteksi | `redirectBase` salah | Cek backend success URL config, match `${Variables.baseUrl}/orders/` |
| Back button keluar tanpa konfirmasi | Lupa pakai PopScope | Wrap Scaffold dengan PopScope |
| WebView crash di Android 8 | minSdk terlalu rendah | Pastikan minSdk >= 19 di build.gradle |
| 403 saat cancel | Status order tidak bisa dicancel | Cek status di backend, hanya `waiting_payment`/`packing` |

---

## 📝 Latihan Mandiri

1. Tambah **filter status** di OrderListPage (chip: Semua / Menunggu / Diproses / Selesai)
2. Tambah **countdown timer** di order `waiting_payment` (sisa waktu dari `willExpiredAt`)
3. Tambah **copy resi number** button (pakai package `clipboard`)
4. Tambah **review/rating** flow untuk order `delivered` (kalau endpoint backend ada)

---

## ➡️ Lanjut ke [Sesi 11 — Profile & Account](./11-profile.md)
