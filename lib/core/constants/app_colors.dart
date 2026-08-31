import 'package:flutter/material.dart';

/// Brand palette. Heritage Navy & Brass: deep navy carries trust,
/// muted brass adds premium warmth, warm-gray neutrals keep it calm.
/// Color is reserved for meaning - never decoration.
class AppColors {
  const AppColors._();

  // ---- Brand scale ----
  /// Primary brand navy for actions, pills and links.
  static const Color navy = Color(0xFF1E3A5C);

  /// Porcelain off-white for text/icons on dark panels.
  static const Color porcelain = Color(0xFFF7F5F0);

  /// Slate for secondary fills and gradient ends.
  static const Color slate = Color(0xFF44546A);

  /// Midnight panel base (hero surfaces, dark cards).
  static const Color midnight = Color(0xFF15263A);

  /// Warm mist for subtle highlights.
  static const Color mist = Color(0xFFD8D4CC);

  // ---- Brass accent (used sparingly: focus, stars, logo) ----
  static const Color brass = Color(0xFFB08A3E);
  static const Color brassLight = Color(0xFFD9BC7A);

  // ---- Functional color (meaning only) ----
  static const Color forest = Color(0xFF2E7D5B);
  static const Color success = forest;
  static const Color danger = Color(0xFFC0504F);
  static const Color info = Color(0xFF4A7DB5);

  /// Muted brand gradients backing AI agent avatars (cycled by index).
  /// Only visible as fallback behind headshots; varies in tone so
  /// adjacent agents remain distinguishable.
  static const List<List<Color>> agentGradients = [
    [Color(0xFF26466B), Color(0xFF16293F)], // navy
    [Color(0xFF8A6B33), Color(0xFF4A3818)], // brass
    [Color(0xFF44546A), Color(0xFF232C3A)], // slate
    [Color(0xFF35624E), Color(0xFF1B332A)], // forest
    [Color(0xFF2E527A), Color(0xFF182C44)], // deep navy
    [Color(0xFF9A7B42), Color(0xFF55411F)], // light brass
    [Color(0xFF3A4A60), Color(0xFF1D2530)], // cool slate
    [Color(0xFF405D4C), Color(0xFF22301F)], // olive
  ];

  /// Complete palette for one theme (light or dark).
  static const AppPalette light = AppPalette(
    background: Color(0xFFFAF8F4),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF1EDE6),
    primary: navy,
    onPrimary: porcelain,
    accent: brass,
    text: Color(0xFF262A31),
    textSubtle: Color(0xFF6F6B62),
    divider: Color(0xFFE7E2D9),
  );

  static const AppPalette dark = AppPalette(
    background: Color(0xFF0F1725),
    surface: Color(0xFF182236),
    surfaceAlt: Color(0xFF223049),
    primary: brassLight,
    onPrimary: midnight,
    accent: brassLight,
    text: porcelain,
    textSubtle: Color(0xFF9BA3B2),
    divider: Color(0xFF2A3950),
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
