import 'package:Makelti/logic/cubit/addMeal/add_meal_cubit.dart';
import 'package:Makelti/logic/cubit/meals/meal_cubit.dart';
import 'package:Makelti/logic/cubit/orders/orders_cubit.dart';
import 'package:Makelti/logic/cubit/faq/faq_cubit.dart';
import 'package:Makelti/logic/cubit/profile/profile_cubit.dart';
import 'package:Makelti/logic/cubit/posts/posts_cubit.dart';
import 'package:Makelti/logic/cubit/stores/stores_cubit.dart';
import 'package:Makelti/logic/cubit/settings/settings_cubit.dart';
import 'package:Makelti/logic/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Makelti/routing/app_router_congif.dart'; 
import 'utils/application_theme.dart';
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
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()..checkAuthStatus()),
        BlocProvider(create: (_) => OrdersCubit()),
        BlocProvider(create: (_) => MealCubit()),
        BlocProvider(create: (_) => AddMealCubit()),
        BlocProvider(create: (_) => FAQCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => PostsCubit()),
        BlocProvider(create: (_) => StoresCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
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