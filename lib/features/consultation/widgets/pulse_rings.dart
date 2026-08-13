import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/models/legal_agent.dart';

class PulseRings extends StatefulWidget {
  const PulseRings({super.key, required this.agent});

  final LegalAgent agent;

  @override
  State<PulseRings> createState() => _PulseRingsState();
}

class _PulseRingsState extends State<PulseRings>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors =
        AppColors.agentGradients[widget.agent.gradientIndex %
            AppColors.agentGradients.length];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double t = _controller.value;
        return SizedBox(
          width: 320,
          height: 320,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(3, (i) {
              final double phase = ((t + i / 3) % 1.0);
              final double size = 140 + phase * 170;
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors[1].withValues(alpha: 0.55 * (1 - phase)),
                    width: 1.6,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}