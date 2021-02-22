import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/service/DBProvider.dart';
import 'package:lists/src/strings.dart';
import 'package:lists/src/utils/context.dart';

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
    final exists = await DBProvider.checkIfTabExists(tabTitle);
    TodoTab tab;
    if (exists) {
      setState(() {
        tabExists = true;
        loading = false;
      });
      return;
    } else {
      final id = await DBProvider.addTab(tabTitle);
      tab = TodoTab(tabTitle, id: id, todoLists: []);
    }
    _reset(tab);
  }

  void _reset([val]) {
    loading = false;
    tabExists = false;
    _titleController.clear();
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
            Strings.newTab,
            style: theme.textTheme.headline6,
          ),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: Strings.title,
              hintText: Strings.title,
              errorText: tabExists ? Strings.tabAlreadyExists : null,
            ),

            //autofocus: true,
          ),
          Container(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: _reset,
                  child: loading
                      ? CircularProgressIndicator()
                      : Text(Strings.cancel),
                  style: TextButton.styleFrom(primary: theme.primaryColor)),
              ElevatedButton(
                onPressed: _titleController.value.text.isNotEmpty
                    ? () => setState(() {
                          loading = true;
                          _addTab();
                        })
                    : null,
                child: Text(Strings.add),
                style: ElevatedButton.styleFrom(
                  primary: theme.primaryColor,
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
