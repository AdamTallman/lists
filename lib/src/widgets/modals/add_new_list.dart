import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/service/DBProvider.dart';
import 'package:lists/src/strings.dart';
import 'package:lists/src/utils/context.dart';

/// Modal form for adding a new list.
/// After the user enters a valid title, a new list is added to the database,
/// and the modal fom returns a freshly created [TodoList] to the callig widget
/// (supposed to be a [TabsContainer]).
class AddNewList extends StatefulWidget {
  /// The database id of the tab to which a new list is being added.
  final int tabId;

  /// Creates a form for adding a new list.
  AddNewList({@required this.tabId});

  @override
  _AddNewListState createState() => _AddNewListState();
}

class _AddNewListState extends State<AddNewList> {
  /// The controller for the title [TextFiled]/
  TextEditingController _titleController = TextEditingController();

  /// Adds the new [TodoList] to the database.
  ///
  /// The [TodoList] is created with [title] from the [TextField], [id] from the
  /// database, and the is return trhough the [Navigator] to the alling widget.
  Future _addList() async {
    final listTitle = _titleController.value.text;

    final id = await DBProvider.addList(listTitle, widget.tabId);
    final list = TodoList(listTitle, id: id, todos: []);
    _reset(list);
  }

  /// Retets the [TextField] and returns the created [TodoList] to the calling
  /// widget.
  ///
  /// If the user tapped 'Cancel' [null] is returned/
  void _reset([val]) {
    _titleController.clear();
    Navigator.of(context).pop<TodoList>(val);
  }

  @override
  void dispose() {
    _titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${Strings.add} ${Strings.list.toLowerCase()}',
            style: theme.textTheme.headline6,
          ),
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: Strings.title,
              hintText: Strings.title,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                // cancel button
                onPressed: _reset,
                child: Text(Strings.cancel),
                style: TextButton.styleFrom(primary: theme.primaryColor),
              ),
              ElevatedButton(
                // add button
                onPressed:
                    _titleController.value.text.isNotEmpty ? _addList : null,
                child: Text(Strings.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
