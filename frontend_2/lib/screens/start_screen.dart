import 'package:Makelti/logic/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstScreen extends StatelessWidget {
  final Widget child;
  const FirstScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final userType = authCubit.state.userType; 

    final tabs = userType == 'cook'
        ? ['/home', '/add_meal', '/orders', '/settings']
        : ['/home', '/menu', '/cart', '/orders', '/settings'];

    final items = userType == 'cook'
        ? const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.lunch_dining), label: 'favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ]
        : const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),

            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ];

    int calculateSelectedIndex() {
      final location = GoRouterState.of(context).uri.toString();
      for (var i = 0; i < tabs.length; i++) {
        if (location.startsWith(tabs[i])) return i;
      }
      return 0;
    }

    void onItemTapped(int index) {
      context.go(tabs[index]);
    }

    final selectedIndex = calculateSelectedIndex();

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed, 
        onTap: onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: items,
      ),
    );
  }
}