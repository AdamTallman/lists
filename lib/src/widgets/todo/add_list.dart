import 'package:flutter/material.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/utils/context.dart';

class AddList extends StatefulWidget {
  final Function(String) addList;

  AddList(this.addList);

  @override
  _AddListState createState() => _AddListState();
}

class _AddListState extends State<AddList> {
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
                  decoration: InputDecoration(hintText: 'Add useless list'),
                  controller: _textController,
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
        : OutlinedButton(
            onPressed: () => setState(() => _add = true),
            child: Text(
              'ADD LIST',
              style: TextStyle(
                color: context.theme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: context.theme.primaryColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
          );
  }
}
