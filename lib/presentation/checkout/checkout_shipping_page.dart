import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../address/address_list_page.dart';
import '../address/address_models.dart';
import 'checkout_confirmation_page.dart';
import 'shipping_selection_page.dart';

class CheckoutShippingPage extends StatefulWidget {
  const CheckoutShippingPage({super.key});

  @override
  State<CheckoutShippingPage> createState() => _CheckoutShippingPageState();
}

class _CheckoutShippingPageState extends State<CheckoutShippingPage> {
  Address _address = AddressStore.instance.selected;
  ShippingOption _shipping = shippingOptions[0];

  Future<void> _pickAddress() async {
    final result = await Navigator.of(context).push<Address>(
      MaterialPageRoute(
        builder: (_) => AddressListPage(selectedId: _address.id),
      ),
    );
    if (result != null) setState(() => _address = result);
  }

  Future<void> _pickShipping() async {
    final result = await Navigator.of(context).push<ShippingOption>(
      MaterialPageRoute(
        builder: (_) => ShippingSelectionPage(selectedId: _shipping.id),
      ),
    );
    if (result != null) setState(() => _shipping = result);
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
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const _Stepper(activeIndex: 1),
          const SizedBox(height: 8),
          const _StepLabels(),
          const SizedBox(height: 24),
          _SectionTitle('Shipping Address'),
          const SizedBox(height: 10),
          _AddressCard(address: _address, onTap: _pickAddress),
          const SizedBox(height: 20),
          _SectionTitle('Shipping Method'),
          const SizedBox(height: 10),
          _ShippingPickerCard(option: _shipping, onTap: _pickShipping),
          const SizedBox(height: 20),
          _SectionTitle('Notes for Seller'),
          const SizedBox(height: 10),
          _NoteField(),
        ],
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
              label: 'Continue to Payment',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CheckoutConfirmationPage(),
                  ),
                );
              },
              height: 49,
              borderRadius: 24.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          _StepDot(state: _stateFor(0)),
          Expanded(child: _Connector(active: activeIndex > 0)),
          _StepDot(state: _stateFor(1)),
          Expanded(child: _Connector(active: activeIndex > 1)),
          _StepDot(state: _stateFor(2)),
        ],
      ),
    );
  }

  _DotState _stateFor(int i) {
    if (i < activeIndex) return _DotState.done;
    if (i == activeIndex) return _DotState.active;
    return _DotState.pending;
  }
}

enum _DotState { done, active, pending }

class _StepDot extends StatelessWidget {
  const _StepDot({required this.state});

  final _DotState state;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _DotState.done:
        return Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 20),
        );
      case _DotState.active:
        return Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        );
      case _DotState.pending:
        return Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFCFD6DC), width: 2),
          ),
        );
    }
  }
}

class _Connector extends StatelessWidget {
  const _Connector({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      color: active ? AppColors.primary : const Color(0xFFCFD6DC),
    );
  }
}

class _StepLabels extends StatelessWidget {
  const _StepLabels();

  static const _labels = ['Address', 'Shipping', 'Payment'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _labels
          .map(
            (l) => Expanded(
              child: Text(
                l,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.sectionTitle);
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.onTap});

  final Address address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_on_outlined,
                  color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          address.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          address.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${address.phone}\n${address.fullAddress}',
                    style: AppTextStyles.bodyMuted,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right,
                size: 22, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _ShippingPickerCard extends StatelessWidget {
  const _ShippingPickerCard({required this.option, required this.onTap});

  final ShippingOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: option.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(option.icon,
                  size: 22, color: AppColors.textPrimary),
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
                  const SizedBox(height: 2),
                  Text('${option.eta} · ${option.priceLabel}',
                      style: AppTextStyles.caption),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                'Change',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 3,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: 'Add note (optional)',
        hintStyle: AppTextStyles.bodyMuted,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
