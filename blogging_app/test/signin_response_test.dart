import 'package:blogging_app/network/models/signin_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('signin response parses token and user fields', () {
    final response = SigninResponse.fromJson({
      'token': 'abc123',
      'user': {
        'username': 'joy',
        'email': 'dsilvajoyal@gmail.com',
        'role': 'user',
        'profileImage': '/images/default.png',
      },
    });

    expect(response.token, 'abc123');
    expect(response.user.username, 'joy');
    expect(response.user.email, 'dsilvajoyal@gmail.com');
    expect(response.user.profileImage, '/images/default.png');
  });
}
