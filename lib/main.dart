import 'package:flutter/material.dart';
import 'package:lists/src/model/todo.dart';
import 'package:lists/src/model/todo_group.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/widgets/custom_icon.dart';
import 'package:lists/src/widgets/tab_container.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoTabs = <ToDoTab>[
      ToDoTab('To Buy', active: true, icon: CustomIcons.bag, toDoGroups: [
        ToDoGroup(
          'Groceries',
          toDos: [
            ToDo('Taters'),
          ],
        ),
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
        body: TabsContaiter(
          tabs: todoTabs,
        ),
      ),
    );
  }
}
