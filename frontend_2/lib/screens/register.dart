import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  // VALIDATION SIMPLE
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) return 'Full name is required';
    return null;
  }

  // REGISTER + SYNC LOGIC
  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      // STEP 1 — REGISTER WITH SUPABASE
      final AuthResponse res = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = res.user;
      final session = res.session;

      if (user == null || session == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration failed. Please verify your email."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final token = session.accessToken;

      // STEP 2 — SYNC WITH FASTAPI BACKEND
      final backendResponse = await http.post(
        Uri.parse("http://localhost:8000/api/auth/sync"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "id": user.id,
          "email": user.email,
          "full_name": _fullNameController.text.trim(),
          "user_type": "customer",
        }),
      );

      if (backendResponse.statusCode != 200) {
        if (!mounted) return;
        final err = jsonDecode(backendResponse.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Backend error: ${err['detail']}"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // SUCCESS
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Utiliser go_router pour la navigation
      context.go('/home');
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unexpected error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Full Name', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullNameController,
                    validator: validateFullName,
                    decoration: InputDecoration(
                      hintText: 'John Doe',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Email', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'you@example.com',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Password', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    validator: validatePassword,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                          : const Text('Create Account', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      context.go('/login');
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.grey[700],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}