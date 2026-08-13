import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class CallControls extends StatelessWidget {
  const CallControls({
    super.key,
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