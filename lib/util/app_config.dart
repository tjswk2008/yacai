final isProd = bool.fromEnvironment('dart.vm.product');
class AppConfig {
  static AppConfig instance = new AppConfig();
  String apiBaseUrl;

  AppConfig();

  static AppConfig getInstance() {
    return instance;
  }

  void init(String baseUrl) {
    apiBaseUrl = baseUrl;
  }
}