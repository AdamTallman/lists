import 'package:flutter/material.dart';
import 'package:lists/src/model/todo.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/widgets/custom_icon.dart';
import 'package:lists/src/widgets/tab_container.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // this is to initialize firebase first
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _init =
      Firebase.initializeApp(); // the error can be ignored

  @override
  Widget build(BuildContext context) {
    final todoTabs = <ToDoTab>[
      ToDoTab('To Buy', active: true, icon: CustomIcons.bag, toDoGroups: [
        TodoList(
          'Groceries',
          toDos: [
            Todo('Taters'),
            Todo('Bunnies'),
          ],
        ),
        TodoList('Stuff', toDos: [
          Todo('Unnacecary item 1'),
          Todo('Random item'),
          Todo('Dome Shit'),
        ])
      ]),
      ToDoTab('To Do', icon: CustomIcons.todo, toDoGroups: []),
      ToDoTab('To Watch', icon: CustomIcons.video, toDoGroups: []),
      ToDoTab('To Add', icon: CustomIcons.add, toDoGroups: []),
      ToDoTab('To Draw', icon: CustomIcons.edit, toDoGroups: []),
      ToDoTab('To Read', icon: CustomIcons.books, toDoGroups: []),
      ToDoTab('To Read', icon: CustomIcons.books, toDoGroups: []),
      ToDoTab('To Read', icon: CustomIcons.books, toDoGroups: []),
    ];

    return MaterialApp(
      theme: AppTheme.theme,
      home: Scaffold(
        body: FutureBuilder(
          future: _init,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('not good');
            if (snapshot.connectionState == ConnectionState.done)
              return TabsContaiter(
                tabs: todoTabs,
              );
            return Text('wait a bit');
          },
        ),
      ),
    );
  }
}
