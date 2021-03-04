import 'package:objectbox/objectbox.dart';

@Entity()
class Todo {
  final String title;
  int id;

  Todo({this.title, this.id});

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(title: map['title'], id: map['id']);
  }
}
