import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'bloc/register_bloc.dart';
import 'otp_page.dart';
import 'widgets/auth_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _agree = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final messenger = ScaffoldMessenger.of(context);
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }
    if (_password.text != _confirm.text) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    if (!_agree) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please accept the terms first')),
      );
      return;
    }
    context.read<RegisterBloc>().add(
          RegisterEvent.register(
            name: _name.text.trim(),
            email: _email.text.trim(),
            phone: _phone.text.trim(),
            password: _password.text,
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
        title: const Text('Create Account'),
      ),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: AppColors.primary),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OtpPage(
                    destination: _email.text.trim(),
                    purpose: OtpPurpose.register,
                  ),
                ),
              );
            },
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg),
                  backgroundColor: AppColors.statusCancelled,
                ),
              );
            },
            orElse: () {},
          );
        },
        child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Join Next Online Store', style: AppTextStyles.h2),
          const SizedBox(height: 6),
          const Text(
            'Create a new account in seconds and start shopping.',
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: 24),
          AuthField(
            controller: _name,
            hint: 'Full name',
            icon: Icons.person_outline,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          AuthField(
            controller: _email,
            hint: 'Email address',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          AuthField(
            controller: _phone,
            hint: 'Phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          AuthField(
            controller: _password,
            hint: 'Password',
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
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agree,
                onChanged: (v) => setState(() => _agree = v ?? false),
                activeColor: AppColors.primary,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              final loading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );
              return PrimaryButton(
                label: loading ? 'Creating...' : 'Create Account',
                onPressed: loading ? () {} : _submit,
                height: 49,
                borderRadius: 24.5,
              );
            },
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account? ',
                  style: AppTextStyles.bodyMuted),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
