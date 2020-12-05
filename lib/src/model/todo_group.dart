import 'package:lists/src/model/todo.dart';

class ToDoGroup {
  final title;
  final List<ToDo> toDos;

  ToDoGroup(this.title, {this.toDos});

  add(ToDo item) {
    toDos.add(item);
  }
}
