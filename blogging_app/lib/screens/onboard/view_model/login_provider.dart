import 'package:blogging_app/network/models/comment_add_response.dart';
import 'package:blogging_app/network/models/comment_list_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../network/models/signin_response.dart';
import '../../../network/service/api_service.dart';
import '../../../network/service/dio_api_helper.dart';
import '../../../services/secure_storage_service.dart';

enum AppStage { splash, onboarding, login, home }

class LoginProvider with ChangeNotifier {
  LoginProvider(this._apiService)
      : _secureStorageService = SecureStorageService();

  final ApiService _apiService;
  final SecureStorageService _secureStorageService;

  AppStage _stage = AppStage.splash;
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  SigninResponseData? _signinResponse;

  AppStage get stage => _stage;
  bool get isUserLoggedIn => _stage == AppStage.home;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  SigninResponseData? get signinResponse => _signinResponse;

  static AppStage resolveStage({
    required String? token,
    required bool hasSeenOnboarding,
  }) {
    if (token != null && token.isNotEmpty) {
      return AppStage.home;
    }
    if (hasSeenOnboarding) {
      return AppStage.login;
    }
    return AppStage.onboarding;
  }

  Future<void> initialize() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    final token = await _secureStorageService.readAuthToken();
    final hasSeenOnboarding = await _secureStorageService.hasSeenOnboarding();

    _token = token;
    DioApiHelper.accessToken = _token;
    _stage = resolveStage(
      token: _token,
      hasSeenOnboarding: hasSeenOnboarding,
    );
    notifyListeners();
  }

  Future<void> finishOnboarding() async {
    _errorMessage = null;
    await _secureStorageService.saveOnboardingSeen(true);
    _stage = AppStage.login;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) {
    return _authenticate(
      request: () => _apiService.signinUser(email: email, password: password),
      goHome: true,
    );
  }

  Future<bool> signup({
    required String username,
    required String email,
    required String password,
  }) {
    return _authenticate(
      request: () => _apiService.createUser(
        username: username,
        email: email,
        password: password,
      ),
      goHome: false,
    );
  }

  Future<void> logout() async {
    _token = null;
    _signinResponse = null;
    DioApiHelper.accessToken = null;
    await _secureStorageService.saveAuthToken(null);
    final hasSeenOnboarding = await _secureStorageService.hasSeenOnboarding();
    _stage = resolveStage(
      token: _token,
      hasSeenOnboarding: hasSeenOnboarding,
    );
    notifyListeners();
  }

  Future<void> _saveSecureToken(String? token) async {
    if (token == null || token.isEmpty) {
      _token = null;
      DioApiHelper.accessToken = null;
    } else {
      _token = token;
      DioApiHelper.accessToken = token;
    }
    await _secureStorageService.saveAuthToken(token);
  }

  Future<bool> _authenticate({
    required Future<SigninResponseData> Function() request,
    required bool goHome,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final signin = await request();
      _signinResponse = signin;
      _token = signin.token;
      DioApiHelper.accessToken = _token;
      await _saveSecureToken(_token);
      if (kDebugMode) {
        debugPrint('LOGIN_TOKEN: $_token');
        debugPrint('USER_EMAIL: ${signin.user.email}');
      }
      _stage = goHome ? AppStage.home : AppStage.login;
      return true;
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map && data['error'] is String) {
        _errorMessage = data['error'] as String;
      } else if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        _errorMessage =
            'Connection failed. Check the server URL and network connection.';
      } else {
        _errorMessage = error.message ?? 'Request failed.';
      }
      return false;
    } on Object catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CommentAddResponseData> addComment({
    required String content,
    required String blogId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.addComment(
        content: content,
        blogId: blogId,
      );
      return response;
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map && data['error'] is String) {
        _errorMessage = data['error'] as String;
      } else if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        _errorMessage =
            'Connection failed. Check the server URL and network connection.';
      } else {
        _errorMessage = error.message ?? 'Request failed.';
      }
      rethrow;
    } on Object catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<CommentListResponseData>> getCommentList({
    required String blogId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getCommentList(blogId: blogId);
      return response;
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map && data['error'] is String) {
        _errorMessage = data['error'] as String;
      } else if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        _errorMessage =
            'Connection failed. Check the server URL and network connection.';
      } else {
        _errorMessage = error.message ?? 'Request failed.';
      }
      rethrow;
    } on Object catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}