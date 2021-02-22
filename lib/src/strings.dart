import 'package:lists/src/app_settings.dart';
import 'package:lists/src/strings.dart';

class Strings {
  static String get add {
    switch (_lang) {
      case Languages.en:
        return "Add";
      case Languages.ru:
        return "Добавить";
    }
  }

  static String get newTab {
    switch (_lang) {
      case Languages.en:
        return 'New Tab';
      case Languages.ru:
        return 'Новая вкладка';
    }
  }

  static String get cancel {
    switch (_lang) {
      case Languages.en:
        return 'Cancel';
      case Languages.ru:
        return 'Отмена';
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

  static String get delete {
    switch (_lang) {
      case Languages.en:
        return 'Delete';
      case Languages.ru:
        return 'Удалить';
    }
  }

  static String get deletedList {
    switch (_lang) {
      case Languages.en:
        return 'Deleted list';
      case Languages.ru:
        return 'удален список';
    }
  }

  static String get deletedTab {
    switch (_lang) {
      case Languages.en:
        return 'Deleted tab';
      case Languages.ru:
        return 'Удалена вкладка';
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

  static String get edit {
    switch (_lang) {
      case Languages.en:
        return 'Edit';
      case Languages.ru:
        return 'Редактировать';
    }
  }

  static String get empty {
    switch (_lang) {
      case Languages.en:
        return 'Nothing here yet';
      case Languages.ru:
        return 'Пусто';
    }
  }

  static String get language {
    switch (_lang) {
      case Languages.en:
        return 'Language';
      case Languages.ru:
        return 'Язык';
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

  static String get save {
    switch (_lang) {
      case Languages.en:
        return 'Save';
      case Languages.ru:
        return 'Сохранить';
    }
  }

  static String get settings {
    switch (_lang) {
      case Languages.en:
        return 'Settings';
      case Languages.ru:
        return 'Настройки';
    }
  }

  static String get tab {
    switch (_lang) {
      case Languages.en:
        return "Tab";
      case Languages.ru:
        return "Вкладка";
    }
  }

  static String get tabAlreadyExists {
    switch (_lang) {
      case Languages.en:
        return 'This tab already exist';
      case Languages.ru:
        return 'Вкладка с таким именем уже существует';
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

  static String get undo {
    switch (_lang) {
      case Languages.en:
        return 'Undo';
      case Languages.ru:
        return 'Отменить';
    }
  }

  static String get valueEmpty {
    switch (_lang) {
      case Languages.en:
        return 'Value is empty';
      case Languages.ru:
        return 'Введите текст';
    }
  }

  static Languages get _lang => AppSettings.instance.language;
}
