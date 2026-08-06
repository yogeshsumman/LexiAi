import 'package:flutter/material.dart';

/// Centralized spacing, radius and elevation tokens.
class AppDimensions {
  const AppDimensions._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double radiusSm = 12.0;
  static const double radiusMd = 20.0;
  static const double radiusLg = 28.0;
  static const double radiusFull = 999.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  /// Default page transition duration for GetX routes.
  static const Duration pageTransition = Duration(milliseconds: 380);
}
