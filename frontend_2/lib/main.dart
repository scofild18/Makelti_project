import 'package:Makelti/screens/kitchen_profile.dart';
import 'package:Makelti/screens/user_kitchen_profile.dart';
import 'package:Makelti/screens/user_profile.dart';

import 'screens/start_screen.dart';
import 'utils/application_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Makelti',
       theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const FirstScreen() 
    );
  }
}
