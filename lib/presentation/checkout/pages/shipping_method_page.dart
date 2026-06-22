import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/step_indicator.dart';
import '../../../core/extensions/currency_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/response/shipping_rate_response_model.dart';
import '../bloc/shipping_bloc.dart';

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
    context
        .read<ShippingBloc>()
        .add(ShippingEvent.calculateRates(widget.addressId));
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
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
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
      return const Center(
        child: Text('Tidak ada kurir yang tersedia ke alamat ini.'),
      );
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: groups
          .expand((group) => [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    group.label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                ...group.rates.map((r) => _rateTile(r)),
              ])
          .toList(),
    );
  }

  Widget _rateTile(ShippingRate rate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.pop(context, rate),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rate.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Estimasi: ${rate.estimateDisplay}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.darkGrey)),
                  ],
                ),
              ),
              Text(
                (rate.price ?? 0).currencyFormatRp,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
