import 'package:blogging_app/screens/onboard/view_model/login_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns home when a secure token exists', () {
    expect(
      LoginProvider.resolveStage(token: 'abc', hasSeenOnboarding: true),
      AppStage.home,
    );
  });

  test('returns login when onboarding was already shown', () {
    expect(
      LoginProvider.resolveStage(token: null, hasSeenOnboarding: true),
      AppStage.login,
    );
  });

  test('returns onboarding when user has not seen onboarding', () {
    expect(
      LoginProvider.resolveStage(token: null, hasSeenOnboarding: false),
      AppStage.onboarding,
    );
  });
}
