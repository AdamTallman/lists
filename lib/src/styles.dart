import 'package:flutter/material.dart';

class AppTheme {
  static final textTheme = TextTheme(
    headline6: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
    ),
  );

  static final theme = ThemeData(
    primaryColor: AppColors.green,
    textTheme: textTheme,
  );

  static final cardTextStyle = TextStyle(
    color: AppColors.text,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
}

class AppColors {
  static const green = Colors.green;
  static const backgroundGrey = Color(0x99E5E5E5);
  static const text = Color(0xFF5D5D5D);
  static const lightGrey = Color(0xFF918D8D);
}
