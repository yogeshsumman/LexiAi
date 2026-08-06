import 'package:flutter/material.dart';

/// Brand palette. Gold + deep navy = classic legal, modernized.
class AppColors {
  const AppColors._();

  // ---- Brand accents (shared across themes) ----
  static const Color gold = Color(0xFFC9A227);
  static const Color goldLight = Color(0xFFE8C96A);
  static const Color goldDeep = Color(0xFF8E6A12);
  static const Color navy = Color(0xFF16294A);
  static const Color steel = Color(0xFF7C93C3);

  static const Color success = Color(0xFF2EBD85);
  static const Color danger = Color(0xFFE5484D);
  static const Color info = Color(0xFF4C7DF0);

  /// Gradients used for AI agent avatars (cycled by index).
  static const List<List<Color>> agentGradients = [
    [Color(0xFFC9A227), Color(0xFF8E6A12)],
    [Color(0xFF4C7DF0), Color(0xFF1D3A8F)],
    [Color(0xFF2EBD85), Color(0xFF0F7A52)],
    [Color(0xFFE5484D), Color(0xFF8F1D3F)],
    [Color(0xFF8B5CF6), Color(0xFF4C1D95)],
    [Color(0xFF06B6D4), Color(0xFF0E7490)],
    [Color(0xFFF59E0B), Color(0xFFB45309)],
    [Color(0xFFEC4899), Color(0xFF9D174D)],
  ];

  /// Complete palette for one theme (light or dark).
  static const AppPalette light = AppPalette(
    background: Color(0xFFF6F4EF),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEFEAE0),
    primary: Color(0xFF16294A),
    onPrimary: Color(0xFFF7F5F0),
    accent: Color(0xFFB8860B),
    text: Color(0xFF1B2230),
    textSubtle: Color(0xFF6B7280),
    divider: Color(0xFFE4DED2),
  );

  static const AppPalette dark = AppPalette(
    background: Color(0xFF0A0F1E),
    surface: Color(0xFF121A2B),
    surfaceAlt: Color(0xFF1C2740),
    primary: Color(0xFFE8C96A),
    onPrimary: Color(0xFF2A1F0A),
    accent: Color(0xFFC9A227),
    text: Color(0xFFEDF0F7),
    textSubtle: Color(0xFF8A94A8),
    divider: Color(0xFF232E47),
  );
}

/// A resolved set of semantic colors for a given brightness.
class AppPalette {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.text,
    required this.textSubtle,
    required this.divider,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color primary;
  final Color onPrimary;
  final Color accent;
  final Color text;
  final Color textSubtle;
  final Color divider;
}
