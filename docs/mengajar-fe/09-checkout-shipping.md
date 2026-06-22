# Sesi 09 — Checkout & Shipping

> ⏱️ Estimasi: 60 menit
> 🎯 Tujuan: Peserta paham flow checkout multi-step: pilih alamat → hitung ongkir (Bitship via backend) → pilih kurir → buat order. Step indicator dipakai untuk UX.

---

## 1. Konsep (5 menit)

### Flow Checkout
```
[CartPage] → tap Checkout
   ↓
[CheckoutPage]
  - List cart items (summary)
  - Pilih alamat (sheet/page)
  - Tap "Pilih Kurir"
   ↓
[ShippingMethodPage]
  - Fetch /api/shipping/rates dengan addressId
  - List rate per grup (express, regular, ekonomi)
  - Pilih salah satu → kembali ke checkout
   ↓
[CheckoutPage] (alamat + kurir terpilih)
  - Tampilkan total + ongkir
  - Tap "Bayar"
   ↓
POST /api/orders → backend bikin invoice Xendit
   ↓
[PaymentPage] (WebView ke invoice URL)
```

### Step Indicator
Tampil di header tiap page:
```
①————②————③
Alamat  Kurir  Bayar
```

Pakai `StepIndicator` widget yang dibuat di Sesi 02.

---

## 2. Shipping Models

`lib/data/models/response/shipping_rate_response_model.dart`:

```dart
import 'dart:convert';

class ShippingRateResponseModel {
  final bool? success;
  final ShippingRateData? data;

  ShippingRateResponseModel({this.success, this.data});

  factory ShippingRateResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return ShippingRateResponseModel(
      success: map['success'],
      data: map['data'] != null ? ShippingRateData.fromMap(map['data']) : null,
    );
  }
}

class ShippingRateData {
  final List<ShippingRate>? express;
  final List<ShippingRate>? regular;
  final List<ShippingRate>? economy;

  ShippingRateData({this.express, this.regular, this.economy});

  factory ShippingRateData.fromMap(Map<String, dynamic> map) => ShippingRateData(
    express: _parseList(map['express']),
    regular: _parseList(map['regular']),
    economy: _parseList(map['economy']),
  );

  static List<ShippingRate>? _parseList(dynamic raw) =>
      raw == null ? null : List<ShippingRate>.from(raw.map((x) => ShippingRate.fromMap(x)));

  List<ShippingRateGroup> get groups {
    final result = <ShippingRateGroup>[];
    if (express != null && express!.isNotEmpty) {
      result.add(ShippingRateGroup(label: 'Express (1-2 hari)', rates: express!));
    }
    if (regular != null && regular!.isNotEmpty) {
      result.add(ShippingRateGroup(label: 'Regular (2-4 hari)', rates: regular!));
    }
    if (economy != null && economy!.isNotEmpty) {
      result.add(ShippingRateGroup(label: 'Ekonomi (4-7 hari)', rates: economy!));
    }
    return result;
  }
}

class ShippingRateGroup {
  final String label;
  final List<ShippingRate> rates;
  ShippingRateGroup({required this.label, required this.rates});
}

class ShippingRate {
  final String? type;
  final String? company;
  final String? courierName;
  final String? courierCode;
  final String? courierServiceName;
  final String? courierServiceCode;
  final int? price;
  final String? duration;
  final String? shipmentDurationRange;

  ShippingRate({
    this.type, this.company, this.courierName, this.courierCode,
    this.courierServiceName, this.courierServiceCode,
    this.price, this.duration, this.shipmentDurationRange,
  });

  factory ShippingRate.fromMap(Map<String, dynamic> map) => ShippingRate(
    type: map['type'],
    company: map['company'],
    courierName: map['courier_name'],
    courierCode: map['courier_code'],
    courierServiceName: map['courier_service_name'],
    courierServiceCode: map['courier_service_code'],
    price: map['price']?.toInt(),
    duration: map['duration'],
    shipmentDurationRange: map['shipment_duration_range'],
  );

  String get displayName => '${courierName ?? ''} ${courierServiceName ?? ''}';
  String get estimateDisplay => shipmentDurationRange ?? duration ?? '-';
}
```

> 💡 Backend mengelompokkan rate jadi 3 tier (express/regular/economy) lewat duration mapping di backend `lib/bitship.ts`.

---

## 3. ShippingRemoteDatasource

`lib/data/datasources/shipping_remote_datasource.dart`:

```dart
import 'dart:convert';
import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import '../models/response/shipping_rate_response_model.dart';
import 'api_helper.dart';
import 'auth_local_datasource.dart';

class ShippingRemoteDatasource {
  Future<Either<String, ShippingRateResponseModel>> calculateRates(int addressId) async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/shipping/rates'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'addressId': addressId}),
      );
      if (response.statusCode == 200) {
        return Right(ShippingRateResponseModel.fromJson(response.body));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal menghitung ongkos kirim');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
```

---

## 4. Order Request Model + Datasource

`lib/data/models/request/order_request_model.dart`:

```dart
import 'dart:convert';

class OrderRequestModel {
  final int addressId;
  final String courierName;
  final String courierCompany;
  final String courierType;
  final int courierPrice;
  final String? notes;

  OrderRequestModel({
    required this.addressId,
    required this.courierName,
    required this.courierCompany,
    required this.courierType,
    required this.courierPrice,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'addressId': addressId,
      'courierName': courierName,
      'courierCompany': courierCompany,
      'courierType': courierType,
      'courierPrice': courierPrice,
    };
    if (notes != null && notes!.isNotEmpty) map['notes'] = notes;
    return map;
  }

  String toJson() => jsonEncode(toMap());
}
```

> Model untuk Order response + OrderRemoteDatasource akan dibikin lengkap di Sesi 10 (Payment & Orders). Untuk sesi ini, cukup pakai `createOrder()` saja.

---

## 5. ShippingBloc

`lib/presentation/checkout/bloc/shipping_bloc.dart` — pattern Bloc + Freezed:

```dart
@freezed
sealed class ShippingEvent with _$ShippingEvent {
  const factory ShippingEvent.calculateRates(int addressId) = _CalculateRates;
}

@freezed
sealed class ShippingState with _$ShippingState {
  const factory ShippingState.initial() = _Initial;
  const factory ShippingState.loading() = _Loading;
  const factory ShippingState.loaded(ShippingRateData data) = _Loaded;
  const factory ShippingState.error(String message) = _Error;
}

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final ShippingRemoteDatasource _datasource;
  ShippingBloc(this._datasource) : super(const ShippingState.initial()) {
    on<_CalculateRates>((event, emit) async {
      emit(const ShippingState.loading());
      final result = await _datasource.calculateRates(event.addressId);
      result.fold(
        (err) => emit(ShippingState.error(err)),
        (data) => emit(ShippingState.loaded(data.data ?? ShippingRateData())),
      );
    });
  }
}
```

---

## 6. CheckoutBloc

Hanya 1 action: createOrder.

```dart
@freezed
sealed class CheckoutEvent with _$CheckoutEvent {
  const factory CheckoutEvent.createOrder(OrderRequestModel request) = _CreateOrder;
}

@freezed
sealed class CheckoutState with _$CheckoutState {
  const factory CheckoutState.initial() = _Initial;
  const factory CheckoutState.loading() = _Loading;
  const factory CheckoutState.success(Order order, String? paymentUrl) = _Success;
  const factory CheckoutState.error(String message) = _Error;
}

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRemoteDatasource _datasource;
  CheckoutBloc(this._datasource) : super(const CheckoutState.initial()) {
    on<_CreateOrder>((event, emit) async {
      emit(const CheckoutState.loading());
      final result = await _datasource.createOrder(event.request);
      result.fold(
        (err) => emit(CheckoutState.error(err)),
        (data) => emit(CheckoutState.success(data.data!, data.paymentUrl)),
      );
    });
  }
}
```

> 💡 `OrderDetailResponseModel.paymentUrl` adalah URL invoice Xendit yang dikembalikan backend setelah POST /api/orders. WebView akan buka URL ini.

---

## 7. ShippingMethodPage

`lib/presentation/checkout/pages/shipping_method_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/core/extensions/currency_ext.dart';
import 'package:flutter_onlinestore_app/core/components/step_indicator.dart';
import 'package:flutter_onlinestore_app/data/models/response/shipping_rate_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/checkout/bloc/shipping_bloc.dart';

class ShippingMethodPage extends StatefulWidget {
  final int addressId;
  const ShippingMethodPage({super.key, required this.addressId});

  @override
  State<ShippingMethodPage> createState() => _ShippingMethodPageState();
}

class _ShippingMethodPageState extends State<ShippingMethodPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShippingBloc>().add(ShippingEvent.calculateRates(widget.addressId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Kurir')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: StepIndicator(
              currentStep: 2,
              totalSteps: 3,
              labels: ['Alamat', 'Kurir', 'Bayar'],
            ),
          ),
          Expanded(
            child: BlocBuilder<ShippingBloc, ShippingState>(
              builder: (context, state) => state.maybeWhen(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (msg) => Center(child: Text(msg)),
                loaded: (data) => _buildList(data),
                orElse: () => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(ShippingRateData data) {
    final groups = data.groups;
    if (groups.isEmpty) {
      return const Center(child: Text('Tidak ada kurir yang tersedia ke alamat ini.'));
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: groups.expand((group) => [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(group.label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        ...group.rates.map((r) => _rateTile(r)),
      ]).toList(),
    );
  }

  Widget _rateTile(ShippingRate rate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => context.pop(rate),  // return rate ke CheckoutPage
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rate.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Estimasi: ${rate.estimateDisplay}',
                    style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                ],
              ),
            ),
            Text(
              (rate.price ?? 0).currencyFormatRp,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 8. CheckoutPage

`lib/presentation/checkout/pages/checkout_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/components/step_indicator.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/core/extensions/currency_ext.dart';
import 'package:flutter_onlinestore_app/data/models/request/order_request_model.dart';
import 'package:flutter_onlinestore_app/data/models/response/address_response_model.dart';
import 'package:flutter_onlinestore_app/data/models/response/shipping_rate_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/address/bloc/address_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/cart/bloc/cart_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/checkout/bloc/checkout_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/checkout/pages/payment_page.dart';
import 'package:flutter_onlinestore_app/presentation/checkout/pages/shipping_method_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Address? _selectedAddress;
  ShippingRate? _selectedRate;

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(const AddressEvent.getAddresses());
    context.read<CartBloc>().add(const CartEvent.getCart());
  }

  double _subtotal(List items) => items.fold<double>(
    0,
    (sum, item) => sum + (item.product?.price ?? '0').toString().toPrice * (item.quantity ?? 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (order, paymentUrl) {
              if (paymentUrl != null && paymentUrl.isNotEmpty) {
                context.pushReplacement(PaymentPage(
                  paymentUrl: paymentUrl,
                  orderNumber: order.orderNumber ?? '',
                ));
              }
            },
            error: (msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg))),
            orElse: () {},
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepIndicator(
                currentStep: 1,
                totalSteps: 3,
                labels: ['Alamat', 'Kurir', 'Bayar'],
              ),
              const SpaceHeight(20),

              // Pilih Alamat
              _section(
                title: 'Alamat Pengiriman',
                child: BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) => state.maybeWhen(
                    loaded: (list) {
                      _selectedAddress ??= list.firstWhere(
                        (a) => a.isDefault == true,
                        orElse: () => list.isEmpty ? Address() : list.first,
                      );
                      final a = _selectedAddress;
                      if (a == null || a.id == null) {
                        return TextButton(
                          onPressed: () {},  // navigate ke AddressListPage
                          child: const Text('Belum ada alamat — tambahkan dulu'),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${a.recipientName} · ${a.phone}'),
                          const SpaceHeight(4),
                          Text(a.fullAddress, style: const TextStyle(color: AppColors.darkGrey)),
                          TextButton(
                            onPressed: () => _pickAddress(list),
                            child: const Text('Ganti Alamat'),
                          ),
                        ],
                      );
                    },
                    orElse: () => const SizedBox(),
                  ),
                ),
              ),

              // Pilih Kurir
              _section(
                title: 'Metode Pengiriman',
                child: _selectedRate == null
                    ? Button.outlined(
                        onPressed: _selectedAddress?.id == null ? null : () async {
                          final picked = await Navigator.push<ShippingRate>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShippingMethodPage(addressId: _selectedAddress!.id!),
                            ),
                          );
                          if (picked != null) setState(() => _selectedRate = picked);
                        },
                        label: 'Pilih Kurir',
                      )
                    : ListTile(
                        title: Text(_selectedRate!.displayName),
                        subtitle: Text(_selectedRate!.estimateDisplay),
                        trailing: Text((_selectedRate!.price ?? 0).currencyFormatRp),
                        onTap: () async {
                          final picked = await Navigator.push<ShippingRate>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShippingMethodPage(addressId: _selectedAddress!.id!),
                            ),
                          );
                          if (picked != null) setState(() => _selectedRate = picked);
                        },
                      ),
              ),

              // Summary
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  final items = state.maybeWhen(loaded: (i) => i, orElse: () => []);
                  final subtotal = _subtotal(items);
                  final shipping = (_selectedRate?.price ?? 0).toDouble();
                  final total = subtotal + shipping;
                  return _section(
                    title: 'Ringkasan',
                    child: Column(
                      children: [
                        _row('Subtotal (${items.length} item)', subtotal.currencyFormatRp),
                        _row('Ongkos Kirim', shipping.currencyFormatRp),
                        const Divider(),
                        _row('Total', total.currencyFormatRp, bold: true),
                      ],
                    ),
                  );
                },
              ),

              const SpaceHeight(24),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  final loading = state.maybeWhen(loading: () => true, orElse: () => false);
                  return Button.filled(
                    onPressed: (_selectedAddress?.id == null || _selectedRate == null || loading)
                        ? null
                        : _checkout,
                    label: loading ? 'Memproses...' : 'Bayar Sekarang',
                    width: double.infinity,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickAddress(List<Address> list) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        children: list.map((a) => ListTile(
          title: Text('${a.label ?? 'Alamat'} — ${a.recipientName}'),
          subtitle: Text(a.fullAddress, maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () {
            setState(() {
              _selectedAddress = a;
              _selectedRate = null;  // reset kurir karena alamat berubah
            });
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }

  void _checkout() {
    if (_selectedAddress?.id == null || _selectedRate == null) return;
    final r = _selectedRate!;
    context.read<CheckoutBloc>().add(CheckoutEvent.createOrder(
      OrderRequestModel(
        addressId: _selectedAddress!.id!,
        courierName: r.courierName ?? '',
        courierCompany: r.company ?? '',
        courierType: r.courierServiceCode ?? '',
        courierPrice: r.price ?? 0,
      ),
    ));
  }

  Widget _section({required String title, required Widget child}) {
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

  Widget _row(String label, String value, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}
```

---

## 9. Register di main.dart

```dart
BlocProvider(create: (_) => ShippingBloc(ShippingRemoteDatasource())),
BlocProvider(create: (_) => CheckoutBloc(OrderRemoteDatasource())),
```

---

## 10. Test Flow

1. Cart → "Checkout" → CheckoutPage
2. Alamat default ter-select otomatis
3. Tap "Pilih Kurir" → ShippingMethodPage muncul
4. Loading spinner → list rate per grup
5. Tap salah satu → kembali ke Checkout, rate ter-set
6. Summary update (subtotal + ongkir + total)
7. Tap "Bayar Sekarang" → loading → push PaymentPage (next sesi)

✅ **Checkpoint**: order tercipta di backend, paymentUrl ter-return.

---

## ✅ Checklist Akhir Sesi 09

- [ ] ShippingRate models (response)
- [ ] OrderRequestModel
- [ ] ShippingRemoteDatasource.calculateRates
- [ ] ShippingBloc + freezed
- [ ] CheckoutBloc + freezed
- [ ] ShippingMethodPage dengan step indicator
- [ ] CheckoutPage dengan address picker + rate picker + summary
- [ ] Test: pilih alamat → kurir → bayar (sampai loading)

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| 400 di /shipping/rates | Address belum punya lat/lng | Pastikan AddressForm save lat/lng |
| Rate list kosong | Lat/lng terlalu dekat dengan toko | Test dengan lokasi yg jelas berbeda |
| 500 di /api/orders | Cart kosong / address invalid | Cek backend log, pastikan cart ada item |
| State reset saat pop dari shipping | Pakai pop(rate) yang benar | Pakai `Navigator.push<ShippingRate>` + `context.pop(rate)` |

---

## 📝 Latihan Mandiri

1. Tambah **catatan untuk kurir** field di CheckoutPage → set ke `notes` di OrderRequestModel
2. Tampilkan **berat total** dari cart (jumlahkan `product.weight * quantity`)
3. Tambah **promo code** input (sementara local discount calculation)
4. Highlight **paling murah** dengan badge di list shipping rate

---

## ➡️ Lanjut ke [Sesi 10 — Payment & Orders](./10-payment-orders.md)
