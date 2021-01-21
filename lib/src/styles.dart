import 'package:flutter/material.dart';

class AppTheme {
  static final primaryColor = Colors.deepPurple;
  static final accentColor = Color(0xFF8AB73A);

  static final textTheme = TextTheme(
    headline6: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
    ),
  );

  static final theme = ThemeData(
    primaryColor: primaryColor,
    accentColor: accentColor,
    textTheme: textTheme,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: primaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    ),
  );

  static final cardTextStyle = TextStyle(
    color: AppColors.text,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
}

class AppColors {
  static const green = Colors.green;
  static const backgroundGrey = Color(0xAAE5E5E5);
  static const text = Color(0xFF5D5D5D);
  static const lightGrey = Color(0xFF918D8D);
  static const tabColors = <Color>[
    Colors.green,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.blue,
    Colors.red,
    Colors.pink,
    Colors.brown,
  ];
}
