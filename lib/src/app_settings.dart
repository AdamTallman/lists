import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const lastOpenedTabString = 'lastOpenedTab';
  static const languageString = 'language';

  int _lastOpenedTab = 0;

  int get lastOpenedTab => _lastOpenedTab;
  set lastOpenedTab(int val) {
    _lastOpenedTab = val;

    SharedPreferences.getInstance()
        .then((prefs) => prefs.setInt(lastOpenedTabString, _lastOpenedTab));
  }

  Languages _language = Languages.en;
  Languages get language => _language;
  set language(Languages val) {
    _language = val;

    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString(languageString, val.toString()));
  }

  static AppSettings _instance;

  static AppSettings get instance {
    if (_instance == null) _instance = AppSettings();
    return _instance;
  }

  Future load() async {
    final prefs = await SharedPreferences.getInstance();
    this._lastOpenedTab = prefs.getInt(lastOpenedTabString) ?? 0;
    this._language = _convertLang(prefs.getString(languageString));
  }

  void save() async {
    // TODO  error handling
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(lastOpenedTabString, _lastOpenedTab);
    prefs.setString(languageString, _language.toString());
  }

  static Languages _convertLang(String str) {
    switch (str) {
      case 'en':
        return Languages.en;
      case 'ru':
        return Languages.ru;
      default:
        return Languages.en;
    }
  }
}

enum Languages { en, ru }
