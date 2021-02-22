import 'package:flutter/material.dart';
import 'package:lists/src/app_settings.dart';
import 'package:lists/src/strings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _updateLanguage(Languages newLang) {
    setState(() => AppSettings.instance.language = newLang);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(Strings.settings),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: Navigator.of(context).pop,
      ),
    );

    final body = Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: Text(Strings.language),
            subtitle: DropdownButton<Languages>(
              value: AppSettings.instance.language,
              onChanged: _updateLanguage,
              items: [
                DropdownMenuItem<Languages>(
                  child: Text('English'),
                  value: Languages.en,
                ),
                DropdownMenuItem<Languages>(
                  child: Text('Русский'),
                  value: Languages.ru,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
