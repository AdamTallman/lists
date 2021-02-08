import 'package:flutter/material.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/utils/context.dart';

class AddListButton extends StatefulWidget {
  final Function(String) addList;

  AddListButton(this.addList);

  @override
  _AddListButtonState createState() => _AddListButtonState();
}

class _AddListButtonState extends State<AddListButton> {
  bool _add;
  final _textController = TextEditingController();

  @override
  void initState() {
    _add = false;
    super.initState();
  }

  void _addNewList() {
    final caption = _textController.value.text;
    widget.addList(caption);
    _clearTextField();
  }

  void _clearTextField() {
    setState(() {
      _add = false;
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _add
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: 'New list'),
                  controller: _textController,
                  autofocus: true,
                  onSubmitted: (_) => _addNewList(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.clear),
                color: AppColors.backgroundGrey,
                onPressed: _clearTextField,
              ),
              IconButton(
                icon: Icon(Icons.done),
                color: Colors.blue,
                onPressed: _addNewList,
              ),
            ],
          )
        : ElevatedButton(
            onPressed: () => setState(() => _add = true),
            child: Text(
              'ADD LIST',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: theme.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
          );
  }
}
