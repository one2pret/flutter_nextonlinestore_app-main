import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'login_page.dart';
import 'widgets/auth_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_password.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 14),
            const Text('Password updated!', style: AppTextStyles.h2),
            const SizedBox(height: 6),
            const Text(
              'You can now sign in with your new password.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Sign In',
              height: 44,
              borderRadius: 22,
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (r) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
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
        title: const Text('New Password'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Create new password', style: AppTextStyles.h2),
          const SizedBox(height: 6),
          const Text(
            'Choose a strong password you have not used before.',
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: 24),
          AuthField(
            controller: _password,
            hint: 'New password',
            icon: Icons.lock_outline,
            obscure: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          AuthField(
            controller: _confirm,
            hint: 'Confirm password',
            icon: Icons.lock_outline,
            obscure: true,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Update Password',
            onPressed: _submit,
            height: 49,
            borderRadius: 24.5,
          ),
        ],
      ),
    );
  }
}
