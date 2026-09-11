import 'app_config/app_config.dart';
import 'main.dart' as app;

void main() {
  app.runBloggingApp(
    flavor: Flavor.dev,
    userBaseUrl: const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://blogging-env.eba-yyr9apua.ap-south-1.elasticbeanstalk.com/api/user/',
    ),
  );
}