import 'package:lists/src/app_settings.dart';
import 'package:lists/src/strings.dart';

class Strings {
  static Languages get _lang => AppSettings.instance.language;

  static String get tab {
    switch (_lang) {
      case Languages.en:
        return "Tab";
      case Languages.ru:
        return "Вкладка";
    }
  }

  static String get add {
    switch (_lang) {
      case Languages.en:
        return "Add";
      case Languages.ru:
        return "Добавить";
    }
  }

  static String get list {
    switch (_lang) {
      case Languages.en:
        return "List";
      case Languages.ru:
        return "Список";
    }
  }

  static String get undo {
    switch (_lang) {
      case Languages.en:
        return 'Undo';
      case Languages.ru:
        return 'Отменить';
    }
  }

  static String get cancel {
    switch (_lang) {
      case Languages.en:
        return 'Cancel';
      case Languages.ru:
        return 'Отменить';
    }
  }

  static String get delete {
    switch (_lang) {
      case Languages.en:
        return 'Delete';
      case Languages.ru:
        return 'Удалить';
    }
  }

  static String get deleteTab {
    switch (_lang) {
      case Languages.en:
        return 'Delete tab';
      case Languages.ru:
        return 'Удалить вкладку';
    }
  }

  static String get wasDeleted {
    switch (_lang) {
      case Languages.en:
        return 'was deleted';
      case Languages.ru:
        return 'удалена';
    }
  }

  static String get caption {
    switch (_lang) {
      case Languages.en:
        return 'Caption';
      case Languages.ru:
        return 'Название';
    }
  }

  static String get title {
    switch (_lang) {
      case Languages.en:
        return 'Title';
      case Languages.ru:
        return 'Название';
    }
  }
}
