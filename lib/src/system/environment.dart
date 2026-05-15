abstract class Environment {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    // defaultValue: 'https://api.dictionaryapi.dev',
  );
}
