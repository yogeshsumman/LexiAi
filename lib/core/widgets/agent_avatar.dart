import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Gradient avatar used for AI agents (emoji mascot on a brand gradient).
class AgentAvatar extends StatelessWidget {
  const AgentAvatar({
    super.key,
    required this.emoji,
    required this.gradientIndex,
    this.size = 56,
    this.showRing = true,
  });

  final String emoji;
  final int gradientIndex;
  final double size;
  final bool showRing;

  @override
  Widget build(BuildContext context) {
    final List<Color> gradient = AppColors
        .agentGradients[gradientIndex % AppColors.agentGradients.length];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: showRing
            ? Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: gradient.last.withValues(alpha: 0.4),
            blurRadius: size * 0.4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: size * 0.48)),
      ),
    );
  }
}
