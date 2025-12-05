
enum AuthStatus { initial, loading, success, failure }

class AuthState {
  final AuthStatus status;
  final String? userType;
  final String? errorMessage;

  AuthState({
    this.status = AuthStatus.initial,
    this.userType,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userType,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userType: userType ?? this.userType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}