import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/response/address_response_model.dart';
import '../bloc/address_bloc.dart';
import 'address_form_page.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(const AddressEvent.getAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alamat Saya')),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (list) => list.isEmpty
                ? const Center(
                    child: Text('Belum ada alamat. Tambahkan dulu.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _addressTile(list[i]),
                  ),
            error: (msg) => Center(child: Text(msg)),
            orElse: () => const SizedBox(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(const AddressFormPage()),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }

  Widget _addressTile(Address a) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
            color: a.isDefault == true
                ? AppColors.primary
                : AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(a.label ?? 'Alamat',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              if (a.isDefault == true)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Utama',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () =>
                    context.push(AddressFormPage(existing: a)),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    size: 18, color: AppColors.error),
                onPressed: () => context
                    .read<AddressBloc>()
                    .add(AddressEvent.deleteAddress(a.id!)),
              ),
            ],
          ),
          Text('${a.recipientName} · ${a.phone}'),
          const SizedBox(height: 4),
          Text(a.fullAddress,
              style: const TextStyle(color: AppColors.darkGrey)),
          if (a.isDefault != true) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context
                  .read<AddressBloc>()
                  .add(AddressEvent.setDefault(a.id!)),
              child: const Text('Jadikan Alamat Utama'),
            ),
          ],
        ],
      ),
    );
  }
}
