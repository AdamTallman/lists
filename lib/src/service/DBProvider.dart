import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/service/sqflite.dart';

class DBProvider {
  static final _dbInstance = SQFLiteProvider.instance;

  static Future<int> addTab(String title) {
    return _dbInstance.addTab(title);
  }

  static Future<int> addList(String title, int tabId) {
    return _dbInstance.addList(title, tabId);
  }

  static Future<int> addTodo(String title, int listId) {
    return _dbInstance.addTodo(title, listId);
  }

  static Future deleteTab(int id) {
    return _dbInstance.deleteTab(id);
  }

  static Future deleteList(int id) {
    return _dbInstance.deleteList(id);
  }

  static Future deleteTodo(int id) {
    return _dbInstance.deleteTodo(id);
  }

  static Future updateListTitle(int id, String newTitle) {
    return _dbInstance.updateListTitle(id, newTitle);
  }

  static Future<bool> checkIfTabExists(String tabTitle) {
    return _dbInstance.checkIfTabExists(tabTitle);
  }

  static Future<List<TodoTab>> getTabs() {
    return _dbInstance.getTabs();
  }
}
