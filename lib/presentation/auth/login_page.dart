import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/components/primary_button.dart';
import '../../core/services/push_notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../home/pages/main_page.dart';
import 'auth_session.dart';
import 'bloc/login_bloc.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';
import 'widgets/auth_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password are required')),
      );
      return;
    }
    context.read<LoginBloc>().add(
          LoginEvent.login(
            email: _email.text.trim(),
            password: _password.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            await state.maybeWhen(
              success: (data) async {
                await AuthLocalDatasource().saveToken(data.token ?? '');
                if (data.user != null) {
                  await AuthLocalDatasource().saveUser(data.user!.toJson());
                }
                AuthSession.instance.signIn(
                  name: data.user?.name ?? 'Customer',
                  email: data.user?.email ?? _email.text.trim(),
                );
                await PushNotificationService.instance
                    .registerTokenAfterLogin();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainPage()),
                );
              },
              error: (msg) async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: AppColors.statusCancelled,
                  ),
                );
              },
              orElse: () async {},
            );
          },
          child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            const _Logo(),
            const SizedBox(height: 28),
            const Text('Welcome Back', style: AppTextStyles.h1),
            const SizedBox(height: 6),
            const Text(
              'Sign in to continue shopping with Next Online Store.',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 28),
            AuthField(
              controller: _email,
              hint: 'Email address',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            AuthField(
              controller: _password,
              hint: 'Password',
              icon: Icons.lock_outline,
              obscure: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _remember,
                  onChanged: (v) => setState(() => _remember = v ?? false),
                  activeColor: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const Text('Remember me', style: AppTextStyles.caption),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                final loading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );
                return PrimaryButton(
                  label: loading ? 'Signing in...' : 'Sign In',
                  onPressed: loading ? () {} : _submit,
                  height: 49,
                  borderRadius: 24.5,
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ",
                    style: AppTextStyles.bodyMuted),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const MainPage()),
                  );
                },
                child: const Text(
                  'Continue as Guest',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                size: 32, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            'Next Online Store',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

