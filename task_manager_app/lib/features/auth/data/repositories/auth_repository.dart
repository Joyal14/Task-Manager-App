import 'package:task_manager_app/core/api/api_client.dart';
import 'package:task_manager_app/core/api/api_endpoints.dart';
import 'package:task_manager_app/features/auth/data/models/login_request_model.dart';
import 'package:task_manager_app/features/auth/data/models/user_model.dart';

/// Auth Repository executing login network calls via Dio ApiClient
class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  /// Perform login POST API request
  Future<UserModel> login(LoginRequestModel request) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    if (response.statusCode == 200 && response.data != null) {
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Login failed with status code ${response.statusCode}');
    }
  }
}
