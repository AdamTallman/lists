import 'package:lists/src/model/todo.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TodoList {
  String title;
  int id;

  //@Transient()
  //final List<Todo> todos;

  final todos = ToMany<Todo>();

  TodoList({this.title, this.id, todos = const <Todo>[]}) {
    this.todos.addAll(todos);
  }

  factory TodoList.fromMap(Map<String, dynamic> map) {
    return TodoList(
      title: map['title'],
      id: map['id'],
      todos: map['todos'] == null
          ? []
          : (map['todos'] as List<Map>)
              .map((todoMap) => Todo.fromMap(todoMap))
              .toList(),
    );
  }

  int get todosCount => todos.length;
  bool get isEmpty => todos.isEmpty;
  bool get isNotEmpty => !isEmpty;

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
