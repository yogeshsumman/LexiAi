import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/agent_avatar.dart';
import '../../../domain/models/legal_agent.dart';

/// Simulated AI video consultation: connecting -> connected, with an
/// animated voice waveform, live captions and call controls.
class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen>
    with SingleTickerProviderStateMixin {
  bool _connected = false;
  bool _muted = false;
  bool _cameraOn = true;
  int _captionIndex = 0;
  Duration _elapsed = Duration.zero;

  late final AnimationController _waveformController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  Timer? _connectTimer;
  Timer? _ticker;

  static const List<String> _captions = [
    '…let me start by reviewing what you just described.',
    'Under the applicable statute, you would need to act within 12 months.',
    "There are two viable paths here — I'll outline both.",
    'Would you like me to draft the notice for you?',
  ];

  @override
  void initState() {
    super.initState();
    _connectTimer = Timer(
      const Duration(milliseconds: 1800),
      _onConnected,
    );
  }

  void _onConnected() {
    if (!mounted) return;
    setState(() => _connected = true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _elapsed += const Duration(seconds: 1);
        _captionIndex = (_elapsed.inSeconds ~/ 4) % _captions.length;
      });
    });
  }

  @override
  void dispose() {
    _connectTimer?.cancel();
    _ticker?.cancel();
    _waveformController.dispose();
    super.dispose();
  }

  String get _clock {
    final int m = _elapsed.inMinutes.remainder(60);
    final int s = _elapsed.inSeconds.remainder(60);
    return '${_elapsed.inMinutes.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final LegalAgent agent = Get.arguments as LegalAgent;
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? const [Color(0xFF0A0F1E), Color(0xFF02040A)]
                : const [Color(0xFF16294A), Color(0xFF0B1526)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _TopBar(agent: agent, clock: _clock, connected: _connected),
              Expanded(
                child: _AgentStage(
                  agent: agent,
                  connected: _connected,
                  waveform: _waveformController,
                ),
              ),
              _CaptionCard(
                connected: _connected,
                caption: _captions[_captionIndex],
              ),
              _Controls(
                muted: _muted,
                cameraOn: _cameraOn,
                onMute: () => setState(() => _muted = !_muted),
                onCamera: () => setState(() => _cameraOn = !_cameraOn),
                onEnd: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.agent,
    required this.clock,
    required this.connected,
  });

  final LegalAgent agent;
  final String clock;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agent.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: connected
                            ? AppColors.success
                            : AppColors.goldLight,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        connected ? 'AI video consultation' : 'Calling…',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lock_rounded,
                  size: 13,
                  color: AppColors.success,
                ),
                const SizedBox(width: 6),
                Text(
                  clock,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentStage extends StatelessWidget {
  const _AgentStage({
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
          ? _ConnectedStage(agent: agent, waveform: waveform)
          : const _ConnectingStage(),
    );
  }
}

class _ConnectingStage extends StatelessWidget {
  const _ConnectingStage();

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
            color: AppColors.goldLight,
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

class _ConnectedStage extends StatelessWidget {
  const _ConnectedStage({required this.agent, required this.waveform});

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
            _PulseRings(agent: agent),
            AgentAvatar(
              emoji: agent.emoji,
              gradientIndex: agent.gradientIndex,
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
            builder: (context, child) => _VoiceWaveform(
              progress: waveform.value,
              color: AppColors.goldLight,
            ),
          ),
        ),
      ],
    );
  }
}

class _PulseRings extends StatefulWidget {
  const _PulseRings({required this.agent});

  final LegalAgent agent;

  @override
  State<_PulseRings> createState() => _PulseRingsState();
}

class _PulseRingsState extends State<_PulseRings>
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

/// Animated equalizer-style voice waveform.
class _VoiceWaveform extends StatelessWidget {
  const _VoiceWaveform({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(240, 44),
      painter: _WaveformPainter(progress: progress, color: color),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  static const int _bars = 28;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 3.4
      ..strokeCap = StrokeCap.round;

    final double gap = size.width / _bars;
    for (int i = 0; i < _bars; i++) {
      final double wave = math.sin(i * 0.9 + progress * math.pi * 2);
      final double amp = 0.25 + 0.75 * ((wave + 1) / 2).abs();
      final double height = 8 + amp * (size.height - 10);
      final double x = i * gap + gap / 2;
      canvas.drawLine(
        Offset(x, (size.height - height) / 2),
        Offset(x, (size.height + height) / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _CaptionCard extends StatelessWidget {
  const _CaptionCard({required this.connected, required this.caption});

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
                color: AppColors.goldLight,
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

class _Controls extends StatelessWidget {
  const _Controls({
    required this.muted,
    required this.cameraOn,
    required this.onMute,
    required this.onCamera,
    required this.onEnd,
  });

  final bool muted;
  final bool cameraOn;
  final VoidCallback onMute;
  final VoidCallback onCamera;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.md,
        AppDimensions.md,
        MediaQuery.of(context).padding.bottom + AppDimensions.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(
            icon: muted ? Icons.mic_off_rounded : Icons.mic_rounded,
            active: !muted,
            onTap: onMute,
          ),
          _ControlButton(
            icon: cameraOn
                ? Icons.videocam_rounded
                : Icons.videocam_off_rounded,
            active: cameraOn,
            onTap: onCamera,
          ),
          _ControlButton(
            icon: Icons.flip_camera_ios_rounded,
            active: true,
            onTap: () {},
          ),
          GestureDetector(
            onTap: onEnd,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.danger,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x99E5484D),
                    blurRadius: 20,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.call_end_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  const _ControlButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.86 : 1,
        duration: const Duration(milliseconds: 130),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.active
                ? Colors.white.withValues(alpha: 0.14)
                : AppColors.danger.withValues(alpha: 0.85),
            border: Border.all(
              color: widget.active
                  ? Colors.white.withValues(alpha: 0.22)
                  : Colors.transparent,
            ),
          ),
          child: Icon(
            widget.icon,
            color: widget.active ? Colors.white : Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
