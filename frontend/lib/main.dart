import 'package:Makelti/screens/start_screen.dart';
import 'package:Makelti/utils/application_theme.dart';
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
