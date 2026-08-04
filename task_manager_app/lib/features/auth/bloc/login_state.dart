import 'package:equatable/equatable.dart';
import 'package:task_manager_app/features/auth/data/models/user_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class LoginInitialState extends LoginState {
  const LoginInitialState();
}

/// Loading State during API request
class LoginLoadingState extends LoginState {
  const LoginLoadingState();
}

/// Success State returning user & token
class LoginSuccessState extends LoginState {
  final UserModel user;

  const LoginSuccessState({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Failure State returning error message
class LoginErrorState extends LoginState {
  final String message;

  const LoginErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
