import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'otp_page.dart';
import 'widgets/auth_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (_email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpPage(
          destination: _email.text.trim(),
          purpose: OtpPurpose.resetPassword,
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
        title: const Text('Forgot Password'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_reset,
                size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: 18),
          const Text(
            'Reset your password',
            textAlign: TextAlign.center,
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 6),
          const Text(
            "Enter the email you used to sign up. We'll send a verification code.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: 24),
          AuthField(
            controller: _email,
            hint: 'Email address',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Send Code',
            onPressed: _submit,
            height: 49,
            borderRadius: 24.5,
          ),
        ],
      ),
    );
  }
}
