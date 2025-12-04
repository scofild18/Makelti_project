// lib/cubit/auth_cubit.dart
import 'package:Makelti/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final res = await authService.login(email, password);

      if (res == null) {
        emit(state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Invalid email or password',
        ));
        return;
      }

      emit(state.copyWith(
        status: AuthStatus.success,
        userType: res['user_type'],
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> logout() async {
    await authService.logout();
    emit(AuthState()); // reset state
  }
}