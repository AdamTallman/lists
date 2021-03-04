// src/model/todo_tab.dart
import 'package:objectbox/objectbox.dart';
import 'package:lists/src/model/todo_list.dart';

@Entity() // objectbox annotation
class TodoTab {
  int id;

  final String title;

  //@Transient()
  //final List<TodoList> todoLists;

  final lists = ToMany<TodoList>();

  TodoTab({this.title, this.id, todoLists = const []}) {
    lists.addAll(todoLists);
  }

  factory TodoTab.fromMap(Map<String, dynamic> map) {
    return TodoTab(
      title: map['title'],
      id: map['id'],
      todoLists: map['lists'] == null
          ? []
          : (map['lists'] as List<Map<String, dynamic>>)
              .map((todoListMap) => TodoList.fromMap(todoListMap))
              .toList(),
    );
  }

  void addList(TodoList list, {int index}) {
    index == null ? lists.add(list) : lists.insert(index, list);
  }

  int get todosCount => lists.isNotEmpty
      ? lists.fold(
          0, (previousValue, todoList) => previousValue + todoList.todosCount)
      : 0;

  bool get isNotEmpty =>
      lists.isNotEmpty &&
      lists.fold(true,
          (previousValue, todoList) => todoList.isNotEmpty && previousValue);
}
