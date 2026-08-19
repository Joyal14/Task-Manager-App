enum Flavor { prod, dev }

class AppConfig {
  String appName = "";
  String baseUrl = "";
  String imageBaseUrl = "";
  String onesignalid = "";
  Flavor flavor = Flavor.dev;

  static AppConfig shared = AppConfig.create();

  factory AppConfig.create({
    String appName = "",
    String baseUrl = "",
    String imageBaseUrl = "",
    String onesignalid = "",
    Flavor flavor = Flavor.dev,
  }) {
    return shared = AppConfig(appName, baseUrl, imageBaseUrl, onesignalid, flavor);
  }
  AppConfig(this.appName, this.baseUrl, this.imageBaseUrl, this.onesignalid, flavor);
}
