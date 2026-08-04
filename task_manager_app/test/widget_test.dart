import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/core/api/api_client.dart';
import 'package:task_manager_app/features/auth/data/repositories/auth_repository.dart';
import 'package:task_manager_app/main.dart';

void main() {
  testWidgets('Login App smoke test', (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authRepository = AuthRepository(apiClient: apiClient);

    await tester.pumpWidget(MyApp(authRepository: authRepository));
    expect(find.byType(MyApp), findsOneWidget);
  });
}
