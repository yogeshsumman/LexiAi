import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CaptionCard extends StatelessWidget {
  const CaptionCard({
    super.key,
    required this.connected,
    required this.caption,
  });

  final bool connected;
  final String caption;

  @override
  Widget build(BuildContext context) {
    if (!connected) {
      return const SizedBox(height: 90);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Container(
          key: ValueKey(caption),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.graphic_eq_rounded,
                size: 18,
                color: AppColors.porcelain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  caption,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 13.5,
                    height: 1.35,
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