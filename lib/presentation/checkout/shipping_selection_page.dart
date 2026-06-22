import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ShippingOption {
  const ShippingOption({
    required this.id,
    required this.name,
    required this.service,
    required this.eta,
    required this.price,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final String service;
  final String eta;
  final double price;
  final IconData icon;
  final Color color;

  String get priceLabel => price == 0 ? 'Free' : '\$${price.toStringAsFixed(2)}';
}

const shippingOptions = <ShippingOption>[
  ShippingOption(
    id: 'jne-reg',
    name: 'JNE',
    service: 'Regular (REG)',
    eta: '2 - 3 days',
    price: 4.99,
    icon: Icons.local_shipping_outlined,
    color: Color(0xFFFFE6EE),
  ),
  ShippingOption(
    id: 'jnt-express',
    name: 'J&T Express',
    service: 'EZ',
    eta: '2 - 4 days',
    price: 3.99,
    icon: Icons.local_shipping_outlined,
    color: Color(0xFFFFF1DE),
  ),
  ShippingOption(
    id: 'sicepat',
    name: 'SiCepat',
    service: 'BEST',
    eta: '1 - 2 days',
    price: 6.50,
    icon: Icons.rocket_launch_outlined,
    color: Color(0xFFE7F1FF),
  ),
  ShippingOption(
    id: 'pos',
    name: 'Pos Indonesia',
    service: 'Standard',
    eta: '5 - 7 days',
    price: 0,
    icon: Icons.outbox,
    color: Color(0xFFE6F4EC),
  ),
];

class ShippingSelectionPage extends StatefulWidget {
  const ShippingSelectionPage({super.key, this.selectedId});

  final String? selectedId;

  @override
  State<ShippingSelectionPage> createState() => _ShippingSelectionPageState();
}

class _ShippingSelectionPageState extends State<ShippingSelectionPage> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId ?? shippingOptions.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Choose Courier'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: shippingOptions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final opt = shippingOptions[i];
          return _CourierTile(
            option: opt,
            selected: opt.id == _selectedId,
            onTap: () => setState(() => _selectedId = opt.id),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: PrimaryButton(
              label: 'Apply',
              height: 49,
              borderRadius: 24.5,
              onPressed: () {
                final selected = shippingOptions
                    .firstWhere((o) => o.id == _selectedId);
                Navigator.of(context).pop(selected);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CourierTile extends StatelessWidget {
  const _CourierTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final ShippingOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentSoft : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderSoft,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: option.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(option.icon,
                  size: 28, color: AppColors.textPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        option.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('· ${option.service}',
                          style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Estimated ${option.eta}',
                      style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  Text(
                    option.priceLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : const Color(0xFFCFD6DC),
                  width: 2,
                ),
              ),
              child: selected
                  ? Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
