import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/service/sqflite.dart';
import 'package:lists/src/utils/context.dart';

class AddNewList extends StatefulWidget {
  final int tabId;

  AddNewList({@required this.tabId});

  @override
  _AddNewListState createState() => _AddNewListState();
}

class _AddNewListState extends State<AddNewList> {
  TextEditingController _titleController = TextEditingController();
  bool loading = false;
  bool tabExists = false;

  Future _addList() async {
    final listTitle = _titleController.value.text;

    loading = false;

    final id = await DBProvider.instance.addList(listTitle, widget.tabId);
    final list = TodoList(listTitle, id: id, todos: []);
    _reset(list);
  }

  void _reset([val]) {
    loading = false;
    _titleController.clear();
    Navigator.of(context).pop<TodoList>(val);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Add list'),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'Title',
              errorText: tabExists ? 'This list already exists' : null,
            ),
          ),
          Container(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _reset,
                child: Text('Cancel'),
                style: TextButton.styleFrom(primary: theme.primaryColor),
              ),
              ElevatedButton(
                  onPressed: _titleController.value.text.isNotEmpty
                      ? () => setState(() {
                            loading = true;
                            _addList();
                          })
                      : null,
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    primary: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
