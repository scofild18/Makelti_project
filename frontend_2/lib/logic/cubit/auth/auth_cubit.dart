// lib/cubit/auth_cubit.dart
import 'package:Makelti/database/app_database.dart';
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
  Future<void> persistSession() async {
  await AppDatabase.instance.saveSession({
    'userType': state.userType,
  });
}
Future<void> restoreSession() async {
  try {
    final session = await AppDatabase.instance.loadSession();

    if (session != null) {
      emit(state.copyWith(
        status: AuthStatus.success,
        userType: session['userType'],
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.initial,
        userType: null,
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      status: AuthStatus.failure,
      errorMessage: "Failed to restore session",
    ));
  }
}

  Future<void> logout() async {
    await authService.logout();
    emit(AuthState()); // reset state
  }
}