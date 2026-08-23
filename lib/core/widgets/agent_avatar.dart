import 'package:flutter/material.dart';

import '../../domain/models/legal_agent.dart';
import '../constants/app_colors.dart';

/// Photorealistic headshot avatar for AI lawyer agents.
///
/// Renders the agent's portrait asset inside a circular frame. If the
/// portrait is missing or fails to load, it degrades gracefully to a
/// brand-gradient monogram, so layouts stay intact during asset swaps.
class AgentAvatar extends StatelessWidget {
  const AgentAvatar({
    super.key,
    required this.agent,
    this.size = 56,
    this.showRing = true,
  });

  final LegalAgent agent;
  final double size;
  final bool showRing;

  @override
  Widget build(BuildContext context) {
    final List<Color> gradient = AppColors
        .agentGradients[agent.gradientIndex % AppColors.agentGradients.length];

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
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: size * 0.28,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          agent.photo,
          width: size,
          height: size,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => Center(
            child: Text(
              agent.initials,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.32,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
