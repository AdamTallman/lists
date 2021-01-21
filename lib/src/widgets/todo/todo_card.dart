import 'package:flutter/material.dart';
import 'package:lists/src/model/todo.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/service/sqflite.dart';
import 'package:lists/src/widgets/todo/todo_widget.dart';

class ToDoCard extends StatefulWidget {
  final TodoList todoList;
  final Function(int) onDelete;

  ToDoCard({@required this.todoList, @required this.onDelete});

  @override
  _ToDoCardState createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {
  bool _addNewTodo;
  bool _edit;
  final _captionTextController = TextEditingController();
  final _textController = TextEditingController();

  void _addNewItem() async {
    final title = _textController.value.text;
    int id = await DBProvider.instance.addTodo(title, widget.todoList.id);
    widget.todoList.add(Todo(title, id: id));
    _resetTextField();
  }

  void _editCaption() {
    final newTitle = _captionTextController.value.text;
    if (newTitle != null &&
        newTitle != '' &&
        newTitle != widget.todoList.title) {
      DBProvider.instance.updateListTitle(widget.todoList.id, newTitle);
      setState(() {
        widget.todoList.title = newTitle;
        _edit = false;
        _setCaptionController();
      });
    }
  }

  void _resetTextField() {
    _textController.clear();
    setState(() {
      this._addNewTodo = false;
    });
  }

  void _removeItem(Todo item) {
    DBProvider.instance.deleteTodo(item.id);
    setState(() {
      widget.todoList.remove(item);
    });
  }

  void _setCaptionController() {
    _captionTextController.value =
        TextEditingValue(text: widget.todoList.title);
  }

  @override
  void initState() {
    _addNewTodo = false;
    _edit = false;

    _setCaptionController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final editCaption = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: _captionTextController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter Caption',
              border: InputBorder.none,
            ),
            onSubmitted: (_) => _editCaption(),
          ),
        ),
        IconButton(
          icon: Icon(Icons.clear),
          color: Colors.red,
          onPressed: () => setState(() {
            _edit = false;
            _setCaptionController();
          }),
        ),
        IconButton(
          icon: Icon(Icons.done),
          color: Colors.blue,
          onPressed: _editCaption,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => setState(() {
            _edit = false;
            widget.onDelete(widget.todoList.id);
          }),
        ),
      ],
    );

    final caption = Container(
      //padding: EdgeInsets.only(left: 16),
      child: _edit
          ? editCaption
          : ListTile(
              title: Row(
                children: [
                  Text(
                    widget.todoList.title,
                    style: context.theme.textTheme.headline6
                        .apply(color: context.theme.primaryColor),
                  ),
                  if (widget.todoList.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(
                        widget.todoList.todosCount.toString(),
                        style: TextStyle(color: context.theme.accentColor),
                      ),
                    ),
                  IconButton(
                      icon: Icon(Icons.create),
                      color: AppColors.backgroundGrey,
                      onPressed: () => setState(() => _edit = true)),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.add),
                color: AppColors.backgroundGrey,
                onPressed: () => setState(() => _addNewTodo = true),
              ),
            ),
    );

    final listLength = widget.todoList.todos.length;

    final todoList = Column(
      children:
          List.generate(_addNewTodo ? listLength + 1 : listLength, (index) {
        return index != listLength
            ? TodoWidget(
                title: widget.todoList.todos[index].title,
                onDone: () => _removeItem(widget.todoList.todos[index]),
              )
            : ListTile(
                title: Expanded(
                  //width: 150,
                  child: TextField(
                    controller: _textController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'To do',
                    ),
                    onSubmitted: (_) => _addNewItem(),
                  ),
                ),
                trailing: FittedBox(
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.clear),
                          color: Colors.red,
                          onPressed: _resetTextField),
                      IconButton(
                        icon: Icon(Icons.done),
                        color: Colors.blue,
                        onPressed: _addNewItem,
                      ),
                    ],
                  ),
                ),
              );
      }),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [caption, todoList],
      ),
    );
  }
}
