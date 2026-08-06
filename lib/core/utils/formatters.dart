/// Number and text formatting helpers used across the UI.
class Formatters {
  Formatters._();

  /// 12000 -> "12k", 980 -> "980", 1234567 -> "1.2M".
  static String compact(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      final double k = value / 1000;
      return k == k.roundToDouble()
          ? '${k.round()}k'
          : '${k.toStringAsFixed(1)}k';
    }
    return '$value';
  }

  /// "12s", "3m", "1h" style durations.
  static String shortDuration(Duration d) {
    if (d.inHours >= 1) return '${d.inHours}h';
    if (d.inMinutes >= 1) return '${d.inMinutes}m';
    return '${d.inSeconds}s';
  }
}
