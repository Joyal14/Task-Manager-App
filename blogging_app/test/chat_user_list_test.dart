import 'package:blogging_app/screens/chat/view_model/chat_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('chat provider exposes available users', () {
    final provider = ChatProvider();

    expect(provider.availableUsers, isNotEmpty);
    expect(provider.availableUsers.first.name, isNotEmpty);
  });
}
