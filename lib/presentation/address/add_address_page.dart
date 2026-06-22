import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'address_models.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key, this.initial});

  final Address? initial;

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  late final TextEditingController _label;
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _detail;
  late final TextEditingController _city;
  late final TextEditingController _postal;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final a = widget.initial;
    _label = TextEditingController(text: a?.label ?? '');
    _name = TextEditingController(text: a?.name ?? '');
    _phone = TextEditingController(text: a?.phone ?? '');
    _detail = TextEditingController(text: a?.detail ?? '');
    _city = TextEditingController(text: a?.city ?? '');
    _postal = TextEditingController(text: a?.postal ?? '');
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _label.dispose();
    _name.dispose();
    _phone.dispose();
    _detail.dispose();
    _city.dispose();
    _postal.dispose();
    super.dispose();
  }

  void _save() {
    if (_name.text.trim().isEmpty || _detail.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name & address detail are required')),
      );
      return;
    }
    final result = Address(
      id: widget.initial?.id ?? AddressStore.instance.nextId(),
      label: _label.text.trim().isEmpty ? 'Other' : _label.text.trim(),
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      detail: _detail.text.trim(),
      city: _city.text.trim(),
      postal: _postal.text.trim(),
      isDefault: _isDefault,
    );
    AddressStore.instance.upsert(result);
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(isEdit ? 'Edit Address' : 'Add Address'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const _MapPreview(),
          const SizedBox(height: 18),
          const _Section('Label'),
          _Field(
            controller: _label,
            hint: 'e.g. Home, Office',
            icon: Icons.bookmark_outline,
          ),
          const SizedBox(height: 14),
          const _Section('Recipient'),
          _Field(
            controller: _name,
            hint: 'Full name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 10),
          _Field(
            controller: _phone,
            hint: 'Phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          const _Section('Address'),
          _Field(
            controller: _detail,
            hint: 'Street, building, unit, RT/RW',
            icon: Icons.location_on_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _Field(
                  controller: _city,
                  hint: 'City',
                  icon: Icons.location_city_outlined,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 120,
                child: _Field(
                  controller: _postal,
                  hint: 'Postal',
                  icon: Icons.markunread_mailbox_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _DefaultToggle(
            value: _isDefault,
            onChanged: (v) => setState(() => _isDefault = v),
          ),
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
              label: isEdit ? 'Save Changes' : 'Save Address',
              onPressed: _save,
              height: 49,
              borderRadius: 24.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 2),
      child: Text(text, style: AppTextStyles.sectionTitle),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMuted,
        prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: _border(AppColors.borderSoft),
        enabledBorder: _border(AppColors.borderSoft),
        focusedBorder: _border(AppColors.primary, 1.5),
      ),
    );
  }

  OutlineInputBorder _border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c, width: w),
      );
}

class _DefaultToggle extends StatelessWidget {
  const _DefaultToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set as default',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text('Use this address for new orders',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0xFFE6F2EF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _MapGridPainter()),
          ),
          Center(
            child: Container(
              width: 53,
              height: 53,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: const Icon(Icons.location_on,
                  color: AppColors.primary, size: 24),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.gps_fixed,
                      size: 14, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Use current location',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
