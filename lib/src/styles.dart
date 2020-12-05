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
}

class AppColors {
  static const green = Colors.green;
  static const backgroundGrey = Color(0xFFE5E5E5);
}
