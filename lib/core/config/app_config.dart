/// Centralized application configuration.
///
/// Keep environment-specific values (API base URLs, feature flags, etc.)
/// here so screens and controllers never hardcode endpoints.
class AppConfig {
  const AppConfig._();

  /// Base URL for the remote REST API (Retrofit).
  static const String baseUrl = 'https://dummyjson.com';

  /// Display name used across the app (splash, onboarding, branding).
  static const String appName = 'LexiAI';

  /// Tagline used in branding moments.
  static const String tagline = 'Legal counsel, powered by AI';

  /// How long the splash screen stays visible before navigating away.
  static const Duration splashDuration = Duration(milliseconds: 2400);
}
