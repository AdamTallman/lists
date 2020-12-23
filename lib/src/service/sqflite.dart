import 'package:sqflite/sqflite.dart';
import 'package:lists/src/model/todo_tab.dart';

// this is all complete shit
class DBProvider {
  static const String dbName = 'lists.db';

  static const String tabsTable = 'Tabs';
  static const String listsTable = 'Lists';
  static const String todosTable = 'Todos';

  Database _database;

  DBProvider._ctor();

  static final instance = DBProvider._ctor();

  Future<Database> get database async {
    _database ??= await _init();
    return _database;
  }

  Future<Database> _init() async {
    const todoPath = 'assets/icons/todo.png';
    const tobuyPath = 'assets/icons/bag.png';

    return await openDatabase(dbName, version: 1, onCreate: (db, _) async {
      await db.execute(
          'CREATE TABLE $tabsTable (id INTEGER PRIMARY KEY, title TEXT, icon TEXT)');
      await db.execute(
          'CREATE TABLE $listsTable (id INTEGER PRIMARY KEY, title TEXT, tab_id INTEGER)');
      await db.execute(
          'CREATE TABLE $todosTable (id INTEGER PRIMARY KEY, title TEXT, list_id INTEGER)');

      await db.rawInsert('INSERT INTO $tabsTable(title, icon) VALUES (?, ?)',
          ['To Do', todoPath]);
      await db.rawInsert('INSERT INTO $tabsTable(title, icon) VALUES (?, ?)',
          ['To Buy', tobuyPath]);
    });
  }

  Future<int> addTab(String title, String icon) async {
    return await (await database).rawInsert(
        'INSERT INTO $tabsTable(title, icon) VALUES(?, ?)', [title, icon]);
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
    await (await database)
        .rawDelete('DELETE FROM $listsTable WHERE id = ?', [id]);
  }

  Future<void> updateListTitle(int id, String newTitle) async {
    await (await database).rawUpdate(
        'UPDATE $listsTable SET title = ? WHERE id = ?', [newTitle, id]);
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

    print(allLists);

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
}
