import 'package:lists/src/model/todo.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/service/DBProvider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lists/src/model/todo_tab.dart';

/// this is all complete shit
class SQFLiteProvider implements DBProvider {
  static const String dbName = 'lists.db';

  static const String tabsTable = 'Tabs';
  static const String listsTable = 'Lists';
  static const String todosTable = 'Todos';

  Database _database;

  SQFLiteProvider._ctor();

  static final instance = SQFLiteProvider._ctor();

  Future<Database> get database async {
    _database ??= await _init();
    return _database;
  }

  Future<Database> _init() async {
    return await openDatabase(dbName, version: 1, onCreate: (db, _) async {
      await db.execute(
          'CREATE TABLE $tabsTable (id INTEGER PRIMARY KEY, title TEXT )');
      await db.execute(
          'CREATE TABLE $listsTable (id INTEGER PRIMARY KEY, title TEXT, tab_id INTEGER)');
      await db.execute(
          'CREATE TABLE $todosTable (id INTEGER PRIMARY KEY, title TEXT, list_id INTEGER)');

      await db.rawInsert('INSERT INTO $tabsTable(title) VALUES (?)', ['To Do']);
      await db
          .rawInsert('INSERT INTO $tabsTable(title) VALUES (?)', ['To Buy']);
    });
  }

  Future<int> addTab(String title) async {
    return await (await database).rawInsert(
        'INSERT INTO $tabsTable(title, icon) VALUES(?, ?)', [title, '']);
  }

  Future<int> addList(String title, int tabId) async {
    return await (await database).rawInsert(
        'INSERT INTO $listsTable(title, tab_id) VALUES(?, ?)', [title, tabId]);
  }

  Future<int> addTodo(String title, int listId) async {
    return await (await database).rawInsert(
        'INSERT INTO $todosTable(title, list_id) VALUES(?, ?)',
        [title, listId]);
  }

  Future<void> deleteTodo(int id) async {
    await (await database)
        .rawDelete('DELETE FROM $todosTable WHERE id = ?', [id]);
  }

  Future<void> deleteList(int id) async {
    await (await database).transaction((txn) async {
      await txn.rawDelete('DELETE FROM $listsTable WHERE id = ?', [id]);
      await txn.rawDelete('DELETE FROM $todosTable WHERE list_id = ?', [id]);
    });
  }

  Future deleteTab(int id) async {
    await (await database).transaction((txn) async {
      final List<int> listIds = (await txn
              .rawQuery('SELECT id from $listsTable WHERE tab_id = ?', [id]))
          .map((list) => list['id'] as int)
          .toList();
      listIds.forEach((listId) async {
        await txn.rawDelete('DELETE FROM $listsTable WHERE id = ?', [listId]);
        await txn
            .rawDelete('DELETE FROM $todosTable WHERE list_id = ?', [listId]);
      });

      await txn.rawDelete('DELETE FROM $tabsTable WHERE id = ?', [id]);
    });
  }

  Future<void> updateListTitle(int id, String newTitle) async {
    await (await database).rawUpdate(
        'UPDATE $listsTable SET title = ? WHERE id = ?', [newTitle, id]);
  }

  Future<bool> checkIfTabExists(String tabTitle) async {
    final result = await (await database)
        .rawQuery('SELECT * FROM $tabsTable WHERE title = ?', [tabTitle]);
    return result != null && result.isNotEmpty;
  }

  Future<List<TodoTab>> getTabs() async {
    final db = await database;
    final tabs = List<TodoTab>();

    final allTabs = (await db.rawQuery('SELECT * FROM $tabsTable')).toList();
    var allLists = (await db.rawQuery('SELECT * FROM $listsTable')).toList();
    final allTodos = (await db.rawQuery('SELECT * FROM $todosTable')).toList();

    allLists = allLists.map((list) {
      final newlist = Map<String, dynamic>.from(list);
      newlist['todos'] =
          allTodos.where((todo) => todo['list_id'] == list['id']).toList();
      return newlist;
    }).toList();

    //print(allLists);

    allTabs.forEach((tab) {
      tab = Map<String, dynamic>.from(tab);
      tab['lists'] =
          allLists.where((list) => list['tab_id'] == tab['id']).toList();
      tabs.add(TodoTab.fromMap(tab));
    });

    return tabs;
  }

  Future<void> check() async {
    List<Map> querry = await (await database).rawQuery('SELECT * FROM Tabs');
    print(querry);
  }

  Future<void> close() async {
    await (await database).close();
  }

  Future<Map<String, dynamic>> loadDatabase() async {
    final db = await database;
    final query = 'SELECT * FROM ';
    final dbMap = Map<String, dynamic>();

    final List<TodoTab> tabs = (await db.rawQuery(query + tabsTable))
        .map((tabMap) => TodoTab.fromMap(tabMap))
        .toList();
    dbMap['tabs'] = tabs;

    final List<TodoList> lists = (await db.rawQuery(query + listsTable))
        .map((listMap) => TodoList.fromMap(listMap))
        .toList();
    dbMap['lists'] = lists;

    final List<Todo> todos = (await db.rawQuery(query + todosTable))
        .map((todosMap) => Todo.fromMap(todosMap))
        .toList();
    dbMap['todos'] = todos;

    return dbMap;
  }
}
