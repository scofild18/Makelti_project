import 'dart:convert';
import 'package:Makelti/logic/cubit/auth/auth_cubit.dart';
import 'package:Makelti/logic/cubit/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:Makelti/widgets/custom_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  final Map<String, dynamic>? extra;
  
  const RegisterScreen({super.key, this.extra});

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
  String _userType = 'customer';

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.extra != null && widget.extra!['showLogoutSuccess'] == true) {
        CustomSnackBar.show(
          context,
          message: 'Logged out successfully',
          type: SnackBarType.success,
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Invalid email format';
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

  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      final AuthResponse res = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = res.user;
      final session = res.session;

      if (user == null || session == null) {
        if (!mounted) return;
        CustomSnackBar.show(
          context,
          message: 'Registration failed. Please verify your email.',
          type: SnackBarType.error,
        );
        return;
      }

      final token = session.accessToken;

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
          "user_type": _userType,
        }),
      );

      if (backendResponse.statusCode != 200) {
        if (!mounted) return;
        final err = jsonDecode(backendResponse.body);
        CustomSnackBar.show(
          context,
          message: "Backend error: ${err['detail']}",
          type: SnackBarType.error,
        );
        return;
      }

      if (!mounted) return;
context.read<AuthCubit>().emit(
  AuthState(
    status: AuthStatus.success,
    userType: _userType,
  ),
);
      CustomSnackBar.show(
        context,
        message: 'Account created successfully!',
        type: SnackBarType.success,
      );

      context.go('/home');
    } on AuthException catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        message: "Registration failed: ${e.message}",
        type: SnackBarType.error,
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        message: "Unexpected error: $e",
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
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
                    child: const Icon(Icons.restaurant_menu, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFF6B35)),
                  ),
                  const SizedBox(height: 24),

                  // Full Name
                  TextFormField(
                    controller: _fullNameController,
                    validator: validateFullName,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'John Doe',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'you@example.com',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    validator: validatePassword,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: '••••••••',
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Type Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _userType = 'customer'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _userType == 'customer' ? const Color(0xFFFF6B35) : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 20,
                                    color: _userType == 'customer' ? Colors.white : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Customer',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: _userType == 'customer' ? Colors.white : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _userType = 'cook'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _userType == 'cook' ? const Color(0xFFFF6B35) : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.restaurant,
                                    size: 20,
                                    color: _userType == 'cook' ? Colors.white : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Cook',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: _userType == 'cook' ? Colors.white : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                          : const Text('Create Account', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.grey[700], decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}