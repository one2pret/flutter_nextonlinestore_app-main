import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../home/home_page.dart';
import 'reset_password_page.dart';

enum OtpPurpose { register, resetPassword }

class OtpPage extends StatefulWidget {
  const OtpPage({
    super.key,
    required this.destination,
    required this.purpose,
  });

  final String destination;
  final OtpPurpose purpose;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _seconds = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) {
        t.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _verify() {
    if (_code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the 6-digit code')),
      );
      return;
    }
    if (widget.purpose == OtpPurpose.resetPassword) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (r) => false,
      );
    }
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
        title: const Text('Verification'),
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
            child: const Icon(Icons.mark_email_read_outlined,
                size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: 18),
          const Text('Enter verification code',
              textAlign: TextAlign.center, style: AppTextStyles.h2),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              style: AppTextStyles.bodyMuted,
              children: [
                const TextSpan(text: 'We sent a 6-digit code to '),
                TextSpan(
                  text: widget.destination,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              return SizedBox(
                width: 44,
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.borderSoft),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 5) {
                      _focusNodes[i + 1].requestFocus();
                    } else if (v.isEmpty && i > 0) {
                      _focusNodes[i - 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Center(
            child: _seconds > 0
                ? Text(
                    'Resend code in ${_seconds}s',
                    style: AppTextStyles.caption,
                  )
                : GestureDetector(
                    onTap: _startTimer,
                    child: const Text(
                      'Resend code',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Verify',
            onPressed: _verify,
            height: 49,
            borderRadius: 24.5,
          ),
        ],
      ),
    );
  }
}
