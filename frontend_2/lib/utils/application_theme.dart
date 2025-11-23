import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: const Color(0xFFFEFBF6),

    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
      labelLarge: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.deepOrange,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFEFBF6),
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xffe97844),
          selectionColor: Color(0x33e97844),
          selectionHandleColor: Color(0xffe97844),
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffe97844),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xffe97844),
      foregroundColor: Colors.white,
    ),


   ) ; ///  Dark Theme
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: const Color(0xFF121212),

    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleLarge: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: const TextStyle(
        fontSize: 18,
        color: Colors.white70,
      ),
      bodyMedium: const TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodySmall: const TextStyle(
        fontSize: 14,
        color: Colors.white60,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.orangeAccent,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
  cursorColor: Color(0xffe97844),   
  selectionColor: Color(0x33e97844),
  selectionHandleColor: Color(0xffe97844),
),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
    ),
  ) ;

}