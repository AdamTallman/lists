import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/service/DBProvider.dart';
import 'package:lists/src/strings.dart';
import 'package:lists/src/utils/context.dart';

class AddNewList extends StatefulWidget {
  final int tabId;

  AddNewList({@required this.tabId});

  @override
  _AddNewListState createState() => _AddNewListState();
}

class _AddNewListState extends State<AddNewList> {
  TextEditingController _titleController = TextEditingController();
  bool _loading = false;

  Future _addList() async {
    final listTitle = _titleController.value.text;

    _loading = false;

    final id = await DBProvider.addList(listTitle, widget.tabId);
    final list = TodoList(listTitle, id: id, todos: []);
    _reset(list);
  }

  void _reset([val]) {
    _loading = false;
    _titleController.clear();
    Navigator.of(context).pop<TodoList>(val);
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
            decoration: InputDecoration(
              labelText: Strings.title,
              hintText: Strings.title,
            ),
          ),
          Container(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _reset,
                child: Text(Strings.cancel),
                style: TextButton.styleFrom(primary: theme.primaryColor),
              ),
              ElevatedButton(
                onPressed: _titleController.value.text.isNotEmpty
                    ? () => setState(() {
                          _loading = true;
                          _addList();
                        })
                    : null,
                child: Text(Strings.add),
              ),
            ],
          )
        ],
      ),
    );
  }
}
