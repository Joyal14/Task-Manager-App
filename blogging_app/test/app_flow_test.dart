import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:blogging_app/main.dart';
import 'package:blogging_app/network/service/api_service.dart';
import 'package:blogging_app/screens/onboard/view_model/login_provider.dart';

class FakeApiService extends ApiService {
  Response<dynamic> _success() {
    return Response<dynamic>(
      requestOptions: RequestOptions(path: '/test'),
      statusCode: 200,
    );
  }

  @override
  Future<Response<dynamic>> signinUser({
    required String email,
    required String password,
  }) async {
    return _success();
  }

  @override
  Future<Response<dynamic>> createUser({
    required String username,
    required String email,
    required String password,
  }) async {
    return _success();
  }
}

void main() {
  testWidgets('shows three onboarding pages before login', (tester) async {
    final auth = LoginProvider(FakeApiService())..initialize();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: auth,
        child: const MyApp(),
      ),
    );

    expect(find.text('Blogging App'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Write your story'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Find your audience'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Keep inspiration close'), findsOneWidget);

    await tester.tap(find.text('Get started'));
    await tester.pump();
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('successful login opens home', (tester) async {
    final auth = LoginProvider(FakeApiService())..finishOnboarding();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: auth,
        child: const MyApp(),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to your blog.'), findsOneWidget);
  });
}