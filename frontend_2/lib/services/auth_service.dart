
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final session = res.session;
    final user = res.user;

    if (session == null || user == null) return null;

    final userProfile = await _client
        .from('users')
        .select('user_type')
        .eq('id', user.id)
        .single();

    return {
      'user': user,
      'user_type': userProfile['user_type'] ?? 'customer',
    };
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}