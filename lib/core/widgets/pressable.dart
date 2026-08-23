import 'package:flutter/material.dart';

import '../constants/app_motion.dart';

/// Wraps any widget with Apple-style press feedback: a subtle scale-down
/// and dim while touched, springing back on release.
///
/// Use on cards, tiles, and icon buttons that lack built-in ink response.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.965,
    this.dim = 0.92,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Scale factor while pressed (1.0 = no scale).
  final double scale;

  /// Opacity multiplier while pressed.
  final double dim;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  void _set(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onTap != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _set(true) : null,
      onTapUp: enabled ? (_) => _set(false) : null,
      onTapCancel: enabled ? () => _set(false) : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.emphasized,
        child: AnimatedOpacity(
          opacity: _pressed ? widget.dim : 1.0,
          duration: AppMotion.fast,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
