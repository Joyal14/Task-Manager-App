import 'app_config/app_config.dart';
import 'main.dart' as app;

void main() {
  app.runBloggingApp(
    flavor: Flavor.dev,
    baseUrl: const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://192.168.1.4:8000/api/user/',
    ),
  );
}