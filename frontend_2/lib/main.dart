import 'screens/start_screen.dart';
import 'utils/application_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/orders_provider.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrdersProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Makelti',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const FirstScreen(),
      ),
    );
  }
}
