import 'package:lists/src/model/todo.dart';

class TodoList {
  final title;
  final List<Todo> toDos;

  TodoList(this.title, {this.toDos = const <Todo>[]});

  add(Todo item) {
    toDos.add(item);
  }

  remove(Todo item) {
    if (toDos.contains(item)) toDos.remove(item);
  }
}
