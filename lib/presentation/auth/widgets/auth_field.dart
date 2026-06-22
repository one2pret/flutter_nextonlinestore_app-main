import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _hide;

  @override
  void initState() {
    super.initState();
    _hide = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _hide,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppTextStyles.bodyMuted,
        prefixIcon: Icon(widget.icon, size: 18, color: AppColors.textMuted),
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _hide ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                onPressed: () => setState(() => _hide = !_hide),
              )
            : null,
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
