class Env {
  Env._();

  static const bool isRelease = bool.fromEnvironment('dart.vm.product');
  static const String openAiAPIKey = String.fromEnvironment('OPEN_AI_API_KEY');
}
