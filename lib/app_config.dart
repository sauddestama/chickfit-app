enum EnvConfig { dev, staging, production }

class AppConfig {
  static const String baseUrlDev = "https://chickfit-backend-dot-chickfit-project.appspot.com";
  static const String baseUrlStaging = "https://epresence.anisal.site";
  static const String baseUrlProd = "https://epresence.anisal.site";

  static String deviceUUID = "";
  late String baseUrl;

  final env = EnvConfig.dev;

  AppConfig() {
    if (env == EnvConfig.dev) {
      baseUrl = baseUrlDev;
    } else if (env == EnvConfig.staging) {
      baseUrl = baseUrlStaging;
    } else if (env == EnvConfig.production) {
      baseUrl = baseUrlProd;
    }
  }
}
