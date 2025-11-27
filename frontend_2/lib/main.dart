import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Makelti/routing/app_router_congif.dart';
import 'package:Makelti/providers/orders_provider.dart'; 
import 'utils/application_theme.dart';
import 'package:Makelti/screens/cook_profile.dart';
import 'package:Makelti/screens/faq_screen.dart';
import 'package:Makelti/screens/home_screen.dart';
import 'package:Makelti/screens/login_screen.dart';
import 'package:Makelti/screens/order_Screen.dart';
import 'package:Makelti/screens/profile_screen.dart';
import 'package:Makelti/screens/register.dart';
import 'package:Makelti/screens/settings_screen.dart';
import 'package:Makelti/screens/user_cook_profile.dart';
import 'package:Makelti/screens/user_profile.dart';
import 'screens/start_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
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