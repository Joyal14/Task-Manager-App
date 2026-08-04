import 'package:equatable/equatable.dart';

/// User and Auth Token model returned from Login API
class UserModel extends Equatable {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String token;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.token,
  });

  /// Factory parser for API response JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? json['username'] as String? ?? 'User',
      lastName: json['lastName'] as String? ?? '',
      token: json['accessToken'] as String? ?? json['token'] as String? ?? '',
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [id, username, email, firstName, lastName, token];
}
