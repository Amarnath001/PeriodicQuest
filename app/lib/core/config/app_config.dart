/// Application configuration resolved at build time.
///
/// Use `--dart-define` for environment-specific values; do not commit secrets.
abstract final class AppConfig {
  /// Reserved for future API base URL; not used by the static-data UI today.
  static String get apiBaseUrl =>
      const String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static bool get isDebug =>
      const bool.fromEnvironment('DEBUG', defaultValue: false);
}
