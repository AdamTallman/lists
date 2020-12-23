import 'package:flutter/material.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/widgets/tab_container.dart';
import 'package:lists/src/service/sqflite.dart';
import 'package:lists/src/widgets/page.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // this is to initialize firebase first
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final body = MaterialApp(
      theme: AppTheme.theme,
      home: Scaffold(body: PageContainer()),
    );

    return body;
  }
}
