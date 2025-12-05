// logic/cubit/auth/auth_cubit.dart

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SupabaseClient _supabase;

  AuthCubit({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client,
        super(AuthInitial());

  // Vérifier si l'utilisateur est déjà connecté au démarrage
  Future<void> checkAuthStatus() async {
    try {
      final session = _supabase.auth.currentSession;
      final user = _supabase.auth.currentUser;

      if (session != null && user != null) {
        
        // Récupérer les infos utilisateur depuis le backend
        final token = session.accessToken;
        final response = await http.get(
          Uri.parse("http://localhost:8000/api/auth/me"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          emit(AuthAuthenticated(
            userId: user.id,
            email: user.email ?? '',
            fullName: data['full_name'] ?? '',
            userType: data['user_type'] ?? 'customer',
          ));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  // LOGIN
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final session = res.session;
      final user = res.user;

      if (session == null || user == null) {
        emit(const AuthError('Invalid email or password'));
        return;
      }

      // Récupérer les infos utilisateur depuis le backend
      final token = session.accessToken;
      final response = await http.get(
        Uri.parse("http://localhost:8000/api/auth/me"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(AuthAuthenticated(
          userId: user.id,
          email: user.email ?? '',
          fullName: data['full_name'] ?? '',
          userType: data['user_type'] ?? 'customer',
        ));
      } else {
        emit(const AuthError('Failed to fetch user data'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Unexpected error: $e'));
    }
  }

  // REGISTER
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String userType,
  }) async {
    emit(AuthLoading());

    try {
      final AuthResponse res = await _supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      final user = res.user;
      final session = res.session;

      if (user == null || session == null) {
        emit(const AuthError('Registration failed. Please verify your email.'));
        return;
      }

      final token = session.accessToken;

      // Sync avec le backend
      final backendResponse = await http.post(
        Uri.parse("http://localhost:8000/api/auth/sync"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "id": user.id,
          "email": user.email,
          "full_name": fullName.trim(),
          "user_type": userType,
        }),
      );

      if (backendResponse.statusCode != 200) {
        final err = jsonDecode(backendResponse.body);
        emit(AuthError("Backend error: ${err['detail']}"));
        return;
      }

      emit(AuthAuthenticated(
        userId: user.id,
        email: user.email ?? '',
        fullName: fullName,
        userType: userType,
      ));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Unexpected error: $e'));
    }
  }

  // LOGOUT
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _supabase.auth.signOut();
      emit(const AuthUnauthenticated(message: 'Logged out successfully'));
    } catch (e) {
      emit(AuthError('Logout failed: $e'));
    }
  }
}