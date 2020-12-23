class Todo {
  final String title;
  final int id;

  Todo(this.title, {this.id});

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(map['title'], id: map['id']);
  }
}
