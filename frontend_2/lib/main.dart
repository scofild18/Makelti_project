import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Makelti/routing/app_router_congif.dart';
import 'package:Makelti/providers/orders_provider.dart'; 
import 'utils/application_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrdersProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Makelti',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: AppRouterConfig.appRouter,
    );
  }
}