import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/lexi_logo.dart';
import '../../../routes/app_routes.dart';

/// 3-page onboarding with parallax-ish staggered transitions.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const List<_SlideData> _slides = [
    _SlideData(
      emoji: '⚖️',
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
    ),
    _SlideData(
      emoji: '📹',
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
    ),
    _SlideData(
      emoji: '💬',
      title: AppStrings.onboardingTitle3,
      subtitle: AppStrings.onboardingSubtitle3,
    ),
  ];

  void _next() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    } else {
      Get.offAllNamed(AppRoutes.main);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LexiLogo(size: 36, showRing: false),
                      SizedBox(width: 10),
                      Text(
                        'LexiAI',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                  if (_page < _slides.length - 1)
                    TextButton(
                      onPressed: () => Get.offAllNamed(AppRoutes.main),
                      child: Text(
                        AppStrings.skip,
                        style: TextStyle(
                          color: c.textSubtle,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final _SlideData slide = _slides[index];
                  return _OnboardingPage(
                    key: ValueKey(index),
                    emoji: slide.emoji,
                    title: slide.title,
                    subtitle: slide.subtitle,
                    index: index,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _page ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: i == _page ? c.accent : c.divider,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    label: _page == _slides.length - 1
                        ? AppStrings.getStarted
                        : 'Continue',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.index,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final int index;

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Illustration(emoji: emoji, index: index),
            const SizedBox(height: 44),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ).animate().fadeIn(
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOut,
            ),
            const SizedBox(height: 14),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: c.textSubtle),
            ).animate().fadeIn(
              delay: const Duration(milliseconds: 180),
              duration: const Duration(milliseconds: 650),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating emoji "hero" inside layered gradient rings.
class _Illustration extends StatelessWidget {
  const _Illustration({required this.emoji, required this.index});

  final String emoji;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x33C9A227), Color(0x1116294A)],
              ),
              border: Border.all(
                color: AppColors.navy.withValues(alpha: 0.35),
                width: 1.4,
              ),
            ),
          ).animate().scale(
            begin: const Offset(0.6, 0.6),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
          ),
          Container(
            width: 136,
            height: 136,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.navy.withValues(alpha: 0.9),
                  AppColors.slate,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.45),
                  blurRadius: 44,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 60)),
            ),
          ).animate().scale(
            begin: const Offset(0.3, 0.3),
            delay: const Duration(milliseconds: 120),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
          ),
        ],
      ),
    );
  }
}

class _SlideData {
  const _SlideData({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final String emoji;
  final String title;
  final String subtitle;
}
