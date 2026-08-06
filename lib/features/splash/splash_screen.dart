import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/lexi_logo.dart';
import '../../../routes/app_routes.dart';

/// Branded splash with a staggered entrance and auto-navigation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(milliseconds: 2600));
    if (!mounted) return;
    Get.offAllNamed(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? const [Color(0xFF0A0F1E), Color(0xFF0F1830)]
                : const [Color(0xFF16294A), Color(0xFF0E1A33)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -80,
              child: _GlowOrb(
                size: 260,
                color: AppColors.gold.withValues(alpha: 0.16),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -60,
              child: _GlowOrb(
                size: 300,
                color: AppColors.steel.withValues(alpha: 0.14),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LexiLogo(size: 108).animate().scale(
                    begin: const Offset(0.4, 0.4),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutBack,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'LexiAI',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(
                    delay: const Duration(milliseconds: 350),
                    duration: const Duration(milliseconds: 700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Legal counsel, powered by AI',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.72),
                      letterSpacing: 0.4,
                    ),
                  ).animate().fadeIn(
                    delay: const Duration(milliseconds: 550),
                    duration: const Duration(milliseconds: 700),
                  ),
                  const SizedBox(height: 46),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Lottie.asset('assets/animations/ai_loader.json'),
                  ).animate().fadeIn(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 600),
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

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 90,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
