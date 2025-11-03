import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FirstScreen extends StatelessWidget {
  final Widget child;
  const FirstScreen({super.key, required this.child});

  // Define your tab routes
  static const List<String> _tabs = [
    '/home',
    '/add_meal',
    '/orders',
    '/settings',
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/add_meal')) return 1;
    if (location.startsWith('/orders')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    context.go(_tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.lunch_dining), label: 'Add meal'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}