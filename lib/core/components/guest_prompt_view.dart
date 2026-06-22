import 'package:flutter/material.dart';

import '../../presentation/auth/login_page.dart';
import '../theme/app_colors.dart';
import 'buttons.dart';
import 'spaces.dart';

class GuestPromptView extends StatelessWidget {
  final String message;
  const GuestPromptView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 72, color: AppColors.primary),
            const SpaceHeight(16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
            const SpaceHeight(20),
            Button.filled(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              label: 'Masuk',
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
