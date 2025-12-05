// logic/cubit/auth/auth_state.dart

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// État initial
class AuthInitial extends AuthState {}

// État de chargement (login, register, logout...)
class AuthLoading extends AuthState {}

// État authentifié avec les infos utilisateur
class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String fullName;
  final String userType; // 'customer' ou 'cook'

  const AuthAuthenticated({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.userType,
  });

  @override
  List<Object?> get props => [userId, email, fullName, userType];
}

// État non authentifié
class AuthUnauthenticated extends AuthState {
  final String? message; // Message optionnel (ex: "Logged out successfully")

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

// État d'erreur
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}