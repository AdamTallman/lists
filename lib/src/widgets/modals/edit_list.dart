import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/strings.dart';

class EditList extends StatelessWidget {
  final TodoList list;
  final TextEditingController _titileController;

  EditList({@required this.list})
      : _titileController = TextEditingController(text: list.title);

  void _reset(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(Strings.edit + ' ' + Strings.list.toLowerCase()),
            TextField(
              controller: _titileController,
              decoration: InputDecoration(
                labelText: Strings.title,
                hintText: Strings.title,
                errorText: _titileController.value.text.isEmpty
                    ? Strings.valueEmpty
                    : null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _reset(context),
                  child: Text(Strings.cancel),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(Strings.save),
                ),
              ],
            )
          ],
        ));
  }
}
