import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/components/step_indicator.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/currency_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/request/order_request_model.dart';
import '../../../data/models/response/address_response_model.dart';
import '../../../data/models/response/cart_response_model.dart';
import '../../../data/models/response/shipping_rate_response_model.dart';
import '../../address/bloc/address_bloc.dart';
import '../../address/pages/address_list_page.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../bloc/checkout_bloc.dart';
import 'payment_page.dart';
import 'shipping_method_page.dart';

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

  double _subtotal(List<CartItem> items) => items.fold<double>(
        0,
        (sum, item) =>
            sum +
            ((item.product?.price ?? '0').toPrice * (item.quantity ?? 1)),
      );

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

  void _pickAddress(List<Address> list) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: list
              .map((a) => ListTile(
                    title: Text('${a.label ?? 'Alamat'} — ${a.recipientName}'),
                    subtitle: Text(a.fullAddress,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      setState(() {
                        _selectedAddress = a;
                        _selectedRate = null;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  Future<void> _pickShipping() async {
    if (_selectedAddress?.id == null) return;
    final picked = await Navigator.push<ShippingRate>(
      context,
      MaterialPageRoute(
        builder: (_) => ShippingMethodPage(addressId: _selectedAddress!.id!),
      ),
    );
    if (picked != null) setState(() => _selectedRate = picked);
  }

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
                  order: order,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Order dibuat tapi payment URL kosong')),
                );
              }
            },
            error: (msg) => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg))),
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
              _section(
                title: 'Alamat Pengiriman',
                child: BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) => state.maybeWhen(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    ),
                    loaded: (list) {
                      if (list.isEmpty) {
                        return TextButton(
                          onPressed: () =>
                              context.push(const AddressListPage()),
                          child: const Text(
                              'Belum ada alamat — tambahkan dulu'),
                        );
                      }
                      _selectedAddress ??= list.firstWhere(
                        (a) => a.isDefault == true,
                        orElse: () => list.first,
                      );
                      final a = _selectedAddress!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${a.recipientName ?? '-'} · ${a.phone ?? ''}'),
                          const SpaceHeight(4),
                          Text(
                            a.fullAddress,
                            style:
                                const TextStyle(color: AppColors.darkGrey),
                          ),
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
              _section(
                title: 'Metode Pengiriman',
                child: BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, addrState) {
                    final hasAddress = addrState.maybeWhen(
                      loaded: (list) => list.isNotEmpty,
                      orElse: () => false,
                    );
                    return _selectedRate == null
                        ? Button.outlined(
                            onPressed: hasAddress ? _pickShipping : null,
                            label: 'Pilih Kurir',
                            width: double.infinity,
                          )
                        : ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(_selectedRate!.displayName),
                            subtitle: Text(_selectedRate!.estimateDisplay),
                            trailing: Text(
                                (_selectedRate!.price ?? 0).currencyFormatRp),
                            onTap: _pickShipping,
                          );
                  },
                ),
              ),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  final items = state.maybeWhen(
                    loaded: (i) => i,
                    orElse: () => <CartItem>[],
                  );
                  final subtotal = _subtotal(items);
                  final shipping = (_selectedRate?.price ?? 0).toDouble();
                  final total = subtotal + shipping;
                  return _section(
                    title: 'Ringkasan',
                    child: Column(
                      children: [
                        _row('Subtotal (${items.length} item)',
                            subtotal.currencyFormatRp),
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
                  final loading = state.maybeWhen(
                      loading: () => true, orElse: () => false);
                  final disabled = _selectedAddress?.id == null ||
                      _selectedRate == null ||
                      loading;
                  return Button.filled(
                    onPressed: disabled ? null : _checkout,
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
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SpaceHeight(8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    final style =
        TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}
