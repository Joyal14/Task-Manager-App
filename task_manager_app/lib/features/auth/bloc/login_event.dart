import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger login form submission
class LoginSubmittedEvent extends LoginEvent {
  final String username;
  final String password;

  const LoginSubmittedEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

/// Reset login state to initial
class LoginResetEvent extends LoginEvent {
  const LoginResetEvent();
}
