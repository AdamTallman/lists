import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/strings.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/widgets/modals/dialog_response.dart';

class EditList extends StatefulWidget {
  final TodoList list;

  EditList({@required this.list});

  @override
  _EditListState createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  TextEditingController _titleController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.list.title);
    super.initState();
  }

  void _save() {
    final newTitle = _titleController.value.text;
    _pop(DialogResponse(answer: DialogAnswer.ok, value: newTitle));
  }

  void _delete() {
    _pop(DialogResponse(answer: DialogAnswer.delete));
  }

  void _cancel() {
    _pop(null);
  }

  void _pop([DialogResponse response]) {
    Navigator.of(context).pop<DialogResponse>(response);
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
          children: [
            Text(Strings.edit + ' ' + Strings.list.toLowerCase()),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: Strings.title,
                hintText: Strings.title,
                errorText: _titleController.value.text.isEmpty
                    ? Strings.valueEmpty
                    : null,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _delete,
                  style: AppTheme.secondaryElevatedButtonStyle,
                  child: Text(Strings.delete),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _cancel,
                      child: Text(Strings.cancel),
                    ),
                    ElevatedButton(
                      onPressed: _save,
                      child: Text(Strings.save),
                    ),
                  ],
                ),
              ],
            )
          ],
        ));
  }
}
