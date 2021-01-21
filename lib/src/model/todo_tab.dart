// src/model/todo_tab.dart

import 'package:lists/src/model/todo_list.dart';

class TodoTab {
  final int id;
  final String title;
  final List<TodoList> todoLists;

  TodoTab(this.title, {this.id, this.todoLists = const []});

  factory TodoTab.fromMap(Map<String, dynamic> map) {
    return TodoTab(map['title'],
        id: map['id'],
        todoLists: map['lists'] == null
            ? []
            : (map['lists'] as List<Map<String, dynamic>>)
                .map((todoListMap) => TodoList.fromMap(todoListMap))
                .toList());
  }

  int get todosCount => todoLists.isNotEmpty
      ? todoLists.fold(
          0, (previousValue, todoList) => previousValue + todoList.todosCount)
      : 0;

  bool get isNotEmpty =>
      todoLists.isNotEmpty &&
      todoLists.fold(true,
          (previousValue, todoList) => todoList.isNotEmpty && previousValue);
}
