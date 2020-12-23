import 'package:flutter/material.dart';
import 'package:lists/src/model/todo.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/widgets/custom_icon.dart';
import 'package:lists/src/widgets/tab_button.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/custom_icon_button.dart';
import 'package:lists/src/service/sqflite.dart';

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
      padding: EdgeInsets.only(left: 16),
      child: _edit
          ? editCaption
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // the caption
                Row(
                  children: [
                    Container(
                      child: Text(
                        widget.todoList.title,
                        style: context.theme.textTheme.headline6
                            .apply(color: context.theme.primaryColor),
                      ),
                    ),
                    IconButton(
                        icon: CustomIcon(
                          CustomIcons.edit,
                          color: AppColors.backgroundGrey,
                        ),
                        onPressed: () => setState(() => _edit = true)),
                  ],
                ),
                IconButton(
                  icon: CustomIcon(
                    CustomIcons.add,
                    color: AppColors.backgroundGrey,
                  ),
                  color: AppColors.backgroundGrey,
                  onPressed: () => setState(() => _addNewTodo = true),
                ),
              ],
            ),
    );

    final listLength = widget.todoList.todos.length;

    final todoList = Column(
      children:
          List.generate(_addNewTodo ? listLength + 1 : listLength, (index) {
        return index != listLength
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.todoList.todos[index].title,
                    style: AppTheme.cardTextStyle,
                  ),
                  IconButton(
                    onPressed: () => _removeItem(widget.todoList.todos[index]),
                    icon: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.lightGrey, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      width: 18,
                      height: 18,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    //width: 150,
                    child: TextField(
                      controller: _textController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'wha\'ever',
                      ),
                      onSubmitted: (_) => _addNewItem(),
                    ),
                  ),
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
              );
      }),
    );

    final body = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        child: todoList,
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: context.theme.primaryColor,
              width: 16,
            ),
            right: BorderSide(width: 0, color: Colors.transparent),
            top: BorderSide(width: 0, color: Colors.transparent),
            bottom: BorderSide(width: 0, color: Colors.transparent),
          ),
          color: AppColors.backgroundGrey,
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [caption, body],
      ),
    );
  }
}
