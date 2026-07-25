class AppConfig {
  static const String BASE_URL = String.fromEnvironment(
    'BASE_URL',
    defaultValue: '',
  );
}
