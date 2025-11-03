import 'package:Makelti/screens/orders_management.dart';
import 'package:Makelti/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import your screens
import 'package:Makelti/screens/start_screen.dart';
import 'package:Makelti/screens/login_screen.dart';
import 'package:Makelti/screens/register.dart';
import 'package:Makelti/screens/home_screen.dart';
import 'package:Makelti/screens/settings_screen.dart';
import 'package:Makelti/screens/profile_screen.dart';
import 'package:Makelti/screens/cook_profile.dart';
import 'package:Makelti/screens/order_Screen.dart';
import 'package:Makelti/screens/add_orders_screen.dart';
import 'package:Makelti/screens/add_meal_screen.dart';
import 'package:Makelti/screens/faq_screen.dart';

// Optional: simple 404 page
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('404 - Page not found')),
    );
  }
}

class AppRouterConfig {
  static final GoRouter appRouter = GoRouter(
    initialLocation: '/home',
    routes: [
      /// --- Start / Auth Screens ---
      GoRoute(
  path: '/',
  name: 'start',
  builder: (context, state) => const SplashScreen(), // ✅ your splash page
),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

     ShellRoute(
  builder: (context, state, child) {
    return FirstScreen(child: child);
  },
  routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add_meal',
      name: 'add_meal',
      builder: (context, state) => const AddMealScreen(),
    ),
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (context, state) => const OrdersManagement(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/cook_profile',
      name: 'cook_profile',
      builder: (context, state) => const CookProfile(),
    ),
  ],
),

      /// --- Other standalone pages (no nav bar) ---
      GoRoute(
        path: '/order',
        name: 'order',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/add_order',
        name: 'add_order',
        builder: (context, state) => const AddOrdersScreen(),
      ),
      GoRoute(
        path: '/faq',
        name: 'faq',
        builder: (context, state) => FAQScreen(),
      ),
      
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}