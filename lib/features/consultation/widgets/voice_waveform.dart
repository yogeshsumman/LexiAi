import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated equalizer-style voice waveform.
class VoiceWaveform extends StatelessWidget {
  const VoiceWaveform({
    super.key,
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(240, 44),
      painter: WaveformPainter(progress: progress, color: color),
    );
  }
}

class WaveformPainter extends CustomPainter {
  WaveformPainter({required this.progress, required this.color});

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
  bool shouldRepaint(WaveformPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}