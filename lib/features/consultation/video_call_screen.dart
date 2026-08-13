import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/models/legal_agent.dart';
import 'widgets/agent_stage.dart';
import 'widgets/call_controls.dart';
import 'widgets/caption_card.dart';
import 'widgets/video_top_bar.dart';

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
              VideoTopBar(agent: agent, clock: _clock, connected: _connected),
              Expanded(
                child: AgentStage(
                  agent: agent,
                  connected: _connected,
                  waveform: _waveformController,
                ),
              ),
              CaptionCard(
                connected: _connected,
                caption: _captions[_captionIndex],
              ),
              CallControls(
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