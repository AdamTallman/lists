import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/service/sqflite.dart';
import 'package:lists/src/widgets/tabs_container.dart';

class AddNewTab extends StatefulWidget {
  @override
  _AddNewTabState createState() => _AddNewTabState();
}

class _AddNewTabState extends State<AddNewTab> {
  TextEditingController _titleController = TextEditingController();
  bool loading = false;
  bool tabExists = false;

  Future _addTab() async {
    final tabTitle = _titleController.value.text;
    final exists = await DBProvider.instance.checkIfTabExists(tabTitle);
    TodoTab tab;
    if (exists) {
      setState(() {
        tabExists = true;
        loading = false;
      });
      return;
    } else {
      final id = await DBProvider.instance.addTab(tabTitle);
      tab = TodoTab(tabTitle, id: id, todoLists: []);
    }
    _reset(tab);
  }

  void _reset([val]) {
    loading = false;
    tabExists = false;
    Navigator.of(context).pop<TodoTab>(val);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Tab',
            style: TextStyle(
              color: context.theme.primaryColor,
            ),
          ),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'Title',
              errorText: tabExists ? 'This tab already exists' : null,
            ),

            //autofocus: true,
          ),
          Container(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: _reset,
                  child: loading ? CircularProgressIndicator() : Text('Cancel'),
                  style: TextButton.styleFrom(
                      primary: context.theme.primaryColor)),
              ElevatedButton(
                onPressed: _titleController.value.text.isNotEmpty
                    ? () => setState(() {
                          loading = true;
                          _addTab();
                        })
                    : null,
                child: Text('Add'),
                style: ElevatedButton.styleFrom(
                  primary: context.theme.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
