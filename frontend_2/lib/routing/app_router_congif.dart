
import 'package:Makelti/logic/cubit/auth/auth_cubit.dart' show AuthCubit;
import 'package:Makelti/screens/cook_home.dart';
import 'package:Makelti/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../screens/client_meal_screen.dart';
import '../screens/cook_homescreen.dart';
import '../screens/see_all_posts.dart';
import '../screens/see_all_stores.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/cook_profile.dart';
import '../screens/order_Screen.dart';
import '../screens/add_orders_screen.dart';
import '../screens/add_meal_screen.dart';
import '../screens/faq_screen.dart';

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
  static GoRouter getRouter(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
     final userType = authCubit.state.userType;

    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'start',
          builder: (context, state) =>  const SplashScreen(),
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
          builder: (context, state) =>   CookDashboardScreen(),
          redirect: (context, state) {
            if (userType == 'cook') return '/cook_home';
            return null; 
          },
        ),
    GoRoute(
      path: '/cook_home',
      name: 'cook_home',
      builder: (context, state) =>  CookDashboardScreen(),
    ),
        GoRoute(
      path: '/add_meal',
      name: 'add_meal',
      builder: (context, state) => const AddMealScreen(),
    ),
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (context, state) => const CookHomescreen(),
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
        GoRoute(
          path: '/client_meal_screen',
          name: 'client_meal_screen',
          builder: (context, state) => const ClientMealScreen(),
        ),
        GoRoute(
          path: '/see_all_posts',
          name: 'see_all_posts',
          builder: (context, state) => const SeeAllPostsScreen(),
        ),
        GoRoute(
          path: '/see_all_stores',
          name: 'see_all_stores',
          builder: (context, state) => const SeeAllStores(),
        ),
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
          builder: (context, state) => const FAQScreen(),
        ),
      ],
      errorBuilder: (context, state) => const NotFoundPage(),
    );
  }
}

