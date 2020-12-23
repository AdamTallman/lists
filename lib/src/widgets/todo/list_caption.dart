import 'package:flutter/material.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/custom_icon.dart';
import 'package:lists/src/service/sqflite.dart';

class ListCaption extends StatefulWidget {
  final String title;
  final Function onSave;
  final Function onAdd;
  final Function delete;

  ListCaption({this.title, this.onSave, this.onAdd, this.delete});

  @override
  _ListCaptionState createState() => _ListCaptionState();
}

class _ListCaptionState extends State<ListCaption> {
  bool _edit;
  final _captionTextController = TextEditingController();

  void _editCaption() {}

  void _deleteList() {}

  @override
  void initState() {
    _edit = false;
    _captionTextController.value = TextEditingValue(text: widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final editCaption = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: _captionTextController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter Caption',
            ),
            onSubmitted: (_) => _editCaption,
          ),
        ),
        IconButton(
          icon: Icon(Icons.clear),
          color: Colors.red,
          onPressed: () => setState(() => _edit = false),
        ),
        IconButton(
          icon: Icon(Icons.done),
          color: Colors.blue,
          onPressed: _editCaption,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: widget.delete,
        )
      ],
    );

    final caption = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // the caption
        Row(
          children: [
            Container(
              child: Text(
                widget.title,
                style: context.theme.textTheme.headline6
                    .apply(color: context.theme.primaryColor),
              ),
            ),
            IconButton(
                icon: CustomIcon(
                  CustomIcons.edit,
                  color: AppColors.backgroundGrey,
                ),
                onPressed: () {}),
          ],
        ),
        IconButton(
          icon: CustomIcon(
            CustomIcons.add,
            color: AppColors.backgroundGrey,
          ),
          color: AppColors.backgroundGrey,
          onPressed: widget.onAdd,
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.only(left: 16),
      child: _edit ? editCaption : caption,
    );
  }
}
