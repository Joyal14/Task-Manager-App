/// API Endpoints configuration
class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL for API requests (e.g. DummyJSON or your backend API server)
  static const String baseUrl = 'https://dummyjson.com';

  /// Auth Endpoints
  static const String login = '/auth/login';
  static const String profile = '/auth/me';

  /// Timeouts
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
