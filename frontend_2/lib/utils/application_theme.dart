import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: const Color(0xFFFEFBF6),

    textTheme: GoogleFonts.poppinsTextTheme(),
fontFamily: GoogleFonts.poppins().fontFamily,

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
      extendedTextStyle:TextStyle(color: Colors.white)
    ),


  );
}