import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/features/auth/data/models/login_request_model.dart';
import 'package:task_manager_app/features/auth/data/repositories/auth_repository.dart';
import 'package:task_manager_app/features/auth/bloc/login_event.dart';
import 'package:task_manager_app/features/auth/bloc/login_state.dart';

/// BLoC controller managing authentication login flow
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(const LoginInitialState()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LoginResetEvent>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoadingState());

    try {
      final request = LoginRequestModel(
        username: event.username.trim(),
        password: event.password,
      );
      final user = await authRepository.login(request);
      emit(LoginSuccessState(user: user));
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }

  void _onLoginReset(
    LoginResetEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(const LoginInitialState());
  }
}
