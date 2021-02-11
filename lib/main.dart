import 'package:flutter/material.dart';
import 'package:lists/src/app_settings.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/widgets/page.dart';
import 'package:lists/src/utils/context.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // this is to initialize firebase first
  AppSettings.instance.load();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: PageContainer(),
    );
  }
}
