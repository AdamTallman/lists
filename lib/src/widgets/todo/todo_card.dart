import 'package:flutter/material.dart';
import 'package:lists/src/app_settings.dart';
import 'package:lists/src/model/todo.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/service/DBProvider.dart';
import 'package:lists/src/strings.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/modals/dialog_response.dart';
import 'package:lists/src/widgets/modals/edit_list.dart';
import 'package:lists/src/widgets/tabs_container.dart';
import 'package:lists/src/widgets/todo/todo_widget.dart';

class ToDoCard extends StatefulWidget {
  final TodoList todoList;
  final void Function(int) deleteCallback;

  ToDoCard({@required this.todoList, @required this.deleteCallback});

  @override
  _ToDoCardState createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {
  bool _addNewTodo;
  final _captionTextController = TextEditingController();
  TextEditingController _textController;
  FocusNode _focusNode;
  AppSettings settings;

  TabsContaiterState _tabsContaiterState;

  TabsContaiterState get _tabsContainer =>
      _tabsContaiterState ?? TabsContaiter.of(context);

  @override
  void initState() {
    _addNewTodo = false;
    _focusNode = FocusNode();
    _textController = TextEditingController();

    _captionTextController.value =
        TextEditingValue(text: widget.todoList.title);

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  void _addNewItem() async {
    final title = _textController.value.text;
    int id = await DBProvider.addTodo(title, widget.todoList.id);
    setState(() => widget.todoList.add(Todo(title, id: id)));
  }

  void _editTitle() async {
    final DialogResponse response = await showModalBottomSheet<DialogResponse>(
      context: context,
      builder: (_) => EditList(list: widget.todoList),
    );

    if (response == null) return;

    if (response.answer == DialogAnswer.ok) {
      if (response.answer == null) {
        // TODO: Error check
        return;
      }
      if (response.value == widget.todoList.title) return; // nothing to do here

      DBProvider.updateListTitle(widget.todoList.id, response.value);
      setState(() {
        widget.todoList.title = response.value;
        _captionTextController.value =
            TextEditingValue(text: widget.todoList.title);
      });
    } // if (response.answer == DialogAnswer.ok

    else if (response.answer == DialogAnswer.delete)
      widget.deleteCallback(widget.todoList.id); // callback to TabWidget
  }

  void _resetTextField() {
    _tabsContainer.showFab();
    _textController.clear();
    setState(() {
      this._addNewTodo = false;
    });
  }

  void _removeItem(Todo item) {
    DBProvider.deleteTodo(item.id);
    setState(() {
      widget.todoList.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomButtons = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            // ===== EDIT button =====
            onPressed: _editTitle,
            style: AppTheme.outlinedBottomButtonStyle,
            icon: Icon(Icons.edit),
            label: Text(
              Strings.edit,
              style: AppTheme.outlinedBottomButtonTextStyle,
            ),
          ),
          SizedBox(
            // spacer
            width: 16,
          ),
          OutlinedButton.icon(
            // ====== ADD button =====
            onPressed: () {
              _tabsContainer.hideFab();
              setState(() => _addNewTodo = true);
            },
            style: AppTheme.outlinedBottomButtonStyle,
            icon: Icon(Icons.add),
            label: Text(
              Strings.add,
              style: AppTheme.outlinedBottomButtonTextStyle,
            ),
          ),
        ],
      ),
    );

    final title = Container(
      padding: widget.todoList.isEmpty
          ? EdgeInsets.only(left: 16, top: 16, bottom: 16)
          : EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: widget.todoList.isEmpty
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          Text(
            widget.todoList.title,
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          if (widget.todoList.isNotEmpty)
            Container(
              margin: EdgeInsets.only(left: 8),
              child: Text(
                widget.todoList.todosCount.toString(),
                style: TextStyle(color: theme.accentColor),
              ),
            ),
        ],
      ),
    );

    final listLength = widget.todoList.todos.length;

    final todoList = Column(
      children: List.generate(
        _addNewTodo ? listLength + 1 : listLength,
        (index) {
          return index != listLength
              ? TodoWidget(
                  title: widget.todoList.todos[index].title,
                  onDone: () => _removeItem(widget.todoList.todos[index]),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          //width: 150,
                          child: TextField(
                            controller: _textController,
                            focusNode: _focusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'To do',
                            ),
                            onSubmitted: (_) {
                              _addNewItem();
                              setState(() {
                                _focusNode.requestFocus();
                                _textController.clear();
                              });
                            },
                          ),
                        ),
                      ],
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
                            onPressed: () {
                              _addNewItem();
                              _resetTextField();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );

    final borderRadius = BorderRadius.circular(4);

    return Container(
      color: Colors.white,
      //margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          title,
          todoList,
          if (!_addNewTodo)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: bottomButtons,
            ),
        ],
      ),
    );
  }
}
