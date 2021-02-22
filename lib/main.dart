import 'package:flutter/material.dart';
import 'package:lists/src/app_settings.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/widgets/pages/page_container.dart';

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
  void initState() {
    //AppSettings.instance.addListener(() {
    // setState(() {});
    //});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: PageContainer(),
    );
  }
}
