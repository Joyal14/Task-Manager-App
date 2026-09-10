import 'app_config/app_config.dart';
import 'main.dart' as app;

void main() {
  app.runBloggingApp(
    flavor: Flavor.dev,
    userBaseUrl: const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://192.168.1.3:8000/api/user/',
    ),
  );
}