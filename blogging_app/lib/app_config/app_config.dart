enum Flavor { prod, dev }

class AppConfig {
  AppConfig._(
    this.appName,
    this.userBaseUrl,
    this.flavor,
  );

  static AppConfig shared = AppConfig.create();

  final String appName;
  final String userBaseUrl;
  final Flavor flavor;

  factory AppConfig.create({
    String appName = 'Blogging App',
    String userBaseUrl = 'https://api.example.com/api/user/',
    Flavor flavor = Flavor.dev,
  }) {
    return shared = AppConfig._(
      appName,
      userBaseUrl,
      flavor,
    );
  }
}