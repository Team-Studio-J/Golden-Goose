import 'package:flutter/material.dart';

class GoldenGooseThemeData {
  static const MaterialColor grey = MaterialColor(
    _greyPrimaryValue,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      350: Color(0xFFD6D6D6),
      // only for raised button while pressed in light theme
      400: Color(0xFFBDBDBD),
      500: Color(_greyPrimaryValue),
      600: Color(0xFF555555),
      700: Color(0xFF313131),
      800: Color(0xFF222222),
      850: Color(0xFF101010),
      // only for background color in dark theme
      900: Color(0xFFFFFFFF),
    },
  );
  static const int _greyPrimaryValue = 0xFF2E2E2E;

  static get value => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(color: Colors.black),
        //primaryColor: Colors.white,
        primarySwatch: Colors.grey,
        fontFamily: 'NextArt',
      );
}
