import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/response/auth_response_model.dart';
import '../bloc/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _name =
      TextEditingController(text: widget.user.name ?? '');
  late final TextEditingController _phone =
      TextEditingController(text: widget.user.phone ?? '');
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (ctx, state) {
        state.maybeWhen(
          updated: (_) {
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profil berhasil diperbarui')),
            );
            Navigator.of(context).pop();
          },
          error: (msg) {
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg)));
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Edit Profil')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomTextField(controller: _name, label: 'Nama'),
            const SpaceHeight(12),
            CustomTextField(
              controller: _phone,
              label: 'Nomor HP',
              keyboardType: TextInputType.phone,
            ),
            const SpaceHeight(24),
            Button.filled(
              onPressed: _submitting
                  ? null
                  : () {
                      if (_name.text.trim().isEmpty ||
                          _phone.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Nama & nomor HP wajib diisi')),
                        );
                        return;
                      }
                      setState(() => _submitting = true);
                      context.read<ProfileBloc>().add(
                            ProfileEvent.updateProfile(
                              name: _name.text.trim(),
                              phone: _phone.text.trim(),
                            ),
                          );
                    },
              label: _submitting ? 'Menyimpan...' : 'Simpan',
            ),
          ],
        ),
      ),
    );
  }
}
