import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/agent_avatar.dart';
import '../../../domain/models/legal_agent.dart';
import 'pulse_rings.dart';
import 'voice_waveform.dart';

class AgentStage extends StatelessWidget {
  const AgentStage({
    super.key,
    required this.agent,
    required this.connected,
    required this.waveform,
  });

  final LegalAgent agent;
  final bool connected;
  final Animation<double> waveform;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: connected
          ? ConnectedStage(agent: agent, waveform: waveform)
          : const ConnectingStage(),
    );
  }
}

class ConnectingStage extends StatelessWidget {
  const ConnectingStage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('connecting'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 88,
          height: 88,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.porcelain,
          ),
        ),
        const SizedBox(height: 26),
        Text(
          AppStrings.connecting,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ConnectedStage extends StatelessWidget {
  const ConnectedStage({
    super.key,
    required this.agent,
    required this.waveform,
  });

  final LegalAgent agent;
  final Animation<double> waveform;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('connected'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            PulseRings(agent: agent),
            AgentAvatar(
              agent: agent,
              size: 168,
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          agent.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          agent.title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 34),
        SizedBox(
          height: 44,
          child: AnimatedBuilder(
            animation: waveform,
            builder: (context, child) => VoiceWaveform(
              progress: waveform.value,
              color: AppColors.porcelain,
            ),
          ),
        ),
      ],
    );
  }
}