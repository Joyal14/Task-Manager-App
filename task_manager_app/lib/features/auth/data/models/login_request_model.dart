import 'package:equatable/equatable.dart';

/// Request body model for Login API call
class LoginRequestModel extends Equatable {
  final String username;
  final String password;

  const LoginRequestModel({
    required this.username,
    required this.password,
  });

  /// Convert model to JSON map payload for Dio request body
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'expiresInMins': 60, // Optional parameter for dummyjson auth API
    };
  }

  @override
  List<Object?> get props => [username, password];
}
