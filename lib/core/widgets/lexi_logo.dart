import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_theme.dart';

/// The LexiAI brand mark: a brass scales-of-justice glyph on a navy disc,
/// optionally surrounded by a soft brass glow ring.
class LexiLogo extends StatelessWidget {
  const LexiLogo({super.key, this.size = 88, this.showRing = true});

  final double size;
  final bool showRing;

  @override
  Widget build(BuildContext context) {
    final double iconSize = size * 0.46;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: kNavyGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.brass.withValues(alpha: 0.35),
            blurRadius: size * 0.35,
            spreadRadius: showRing ? size * 0.05 : 0,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.balance_rounded,
          size: iconSize,
          color: AppColors.brassLight,
        ),
      ),
    );
  }
}
