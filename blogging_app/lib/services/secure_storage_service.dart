import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  static const String onboardingSeenKey = 'onboarding_seen';
  static const String authTokenKey = 'secure_token';

  Future<void> saveAuthToken(String? token) async {
    if (token == null || token.isEmpty) {
      await _secureStorage.delete(key: authTokenKey);
      return;
    }

    await _secureStorage.write(key: authTokenKey, value: token);
  }

  Future<String?> readAuthToken() async {
    return _secureStorage.read(key: authTokenKey);
  }

  Future<void> saveOnboardingSeen(bool seen) async {
    await _secureStorage.write(
      key: onboardingSeenKey,
      value: seen ? 'true' : 'false',
    );
  }

  Future<bool> hasSeenOnboarding() async {
    final value = await _secureStorage.read(key: onboardingSeenKey);
    return value == 'true';
  }
}
