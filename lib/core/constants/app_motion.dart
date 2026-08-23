import 'package:flutter/animation.dart';

/// Centralized motion tokens for the LexiAI motion language.
///
/// Principles:
/// - Things *arrive*, they never slam: emphasized decelerate curves.
/// - Fast enough to feel instant, slow enough to be seen (150–420ms).
/// - One gentle overshoot curve reserved for playful micro-interactions.
class AppMotion {
  const AppMotion._();

  // ---- Durations ----
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);
  static const Duration dramatic = Duration(milliseconds: 700);

  /// Signature arrival curve: fast start, long silky settle.
  static const Curve emphasized = Cubic(0.22, 1.0, 0.36, 1.0);

  /// Sharper entrance for elements that slide over content.
  static const Curve emphasizedAccelerate = Cubic(0.05, 0.7, 0.1, 1.0);

  /// Gentle overshoot for micro-delights (badges, toggles, nav pills).
  static const Curve spring = Cubic(0.34, 1.56, 0.64, 1.0);

  /// Standard stagger step for list/grid entrances.
  static const Duration staggerStep = Duration(milliseconds: 45);
}
