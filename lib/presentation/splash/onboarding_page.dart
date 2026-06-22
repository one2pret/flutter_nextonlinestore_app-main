import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../auth/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _slides = <_Slide>[
    _Slide(
      icon: Icons.shopping_bag_outlined,
      title: 'Discover Quality Products',
      subtitle:
          'Thousands of curated items from trusted sellers, all in one place.',
      color: AppColors.accentSoft,
    ),
    _Slide(
      icon: Icons.local_shipping_outlined,
      title: 'Fast & Safe Delivery',
      subtitle:
          'Choose from multiple couriers and track your package in real time.',
      color: AppColors.primarySoft,
    ),
    _Slide(
      icon: Icons.verified_user_outlined,
      title: 'Secure Payment',
      subtitle: 'Pay with cards, e-wallets, or bank transfer. 100% protected.',
      color: AppColors.accentSoft,
    ),
  ];

  void _skipToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final last = _index == _slides.length - 1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipToLogin,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: PrimaryButton(
                label: last ? 'Get Started' : 'Next',
                height: 49,
                borderRadius: 24.5,
                onPressed: () {
                  if (last) {
                    _skipToLogin();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: slide.color,
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 88, color: AppColors.primary),
          ),
          const SizedBox(height: 32),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.55,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
