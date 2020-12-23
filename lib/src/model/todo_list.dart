import 'package:lists/src/model/todo.dart';

class TodoList {
  String title;
  final int id;
  final List<Todo> todos;

  TodoList(this.title, {this.id, this.todos = const <Todo>[]});

  factory TodoList.fromMap(Map<String, dynamic> map) {
    return TodoList(map['title'],
        id: map['id'],
        todos: map['todos'] == null
            ? []
            : (map['todos'] as List<Map>)
                .map((todoMap) => Todo.fromMap(todoMap))
                .toList());
  }

  add(Todo item) {
    todos.add(item);
  }

  updateTitle(String newTitle) {
    title = newTitle;
  }

  remove(Todo item) {
    if (todos.contains(item)) todos.remove(item);
  }
}
