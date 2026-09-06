enum Flavor { prod, dev }

class AppConfig {
  AppConfig._(
    this.appName,
    this.baseUrl,
    this.flavor,
  );

  static AppConfig shared = AppConfig.create();

  final String appName;
  final String baseUrl;
  final Flavor flavor;

  factory AppConfig.create({
    String appName = 'Blogging App',
    String baseUrl = 'https://api.example.com/api/v1/',
    Flavor flavor = Flavor.dev,
  }) {
    return shared = AppConfig._(appName, baseUrl, flavor);
  }
}