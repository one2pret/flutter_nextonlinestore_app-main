import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'add_address_page.dart';
import 'address_models.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key, this.selectedId});

  final String? selectedId;

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  late String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId ?? AddressStore.instance.selected.id;
  }

  Future<void> _openEditor({Address? initial}) async {
    final result = await Navigator.of(context).push<Address>(
      MaterialPageRoute(builder: (_) => AddAddressPage(initial: initial)),
    );
    if (result != null) {
      setState(() {
        _selectedId = result.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = AddressStore.instance.items;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('My Addresses'),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'No addresses yet',
                style: AppTextStyles.bodyMuted,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final a = items[i];
                return _AddressTile(
                  address: a,
                  selected: a.id == _selectedId,
                  onSelect: () => setState(() => _selectedId = a.id),
                  onEdit: () => _openEditor(initial: a),
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
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => _openEditor(),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add New'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Use Selected',
                    height: 48,
                    borderRadius: 24,
                    onPressed: () {
                      final selected = AddressStore.instance.items.firstWhere(
                        (e) => e.id == _selectedId,
                        orElse: () => AddressStore.instance.selected,
                      );
                      Navigator.of(context).pop(selected);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.address,
    required this.selected,
    required this.onSelect,
    required this.onEdit,
  });

  final Address address;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentSoft : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderSoft,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: selected ? AppColors.primary : AppColors.textMuted,
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
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          address.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      GestureDetector(
                        onTap: onEdit,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.edit_outlined,
                              size: 18, color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${address.name}  ·  ${address.phone}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(address.fullAddress, style: AppTextStyles.bodyMuted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
