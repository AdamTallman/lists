import 'package:flutter/material.dart';
import 'package:lists/src/model/todo.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/widgets/custom_icon.dart';
import 'package:lists/src/widgets/tab_button.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/custom_icon_button.dart';

class ToDoCard extends StatefulWidget {
  final TodoList toDoGroup;

  ToDoCard(this.toDoGroup);

  @override
  _ToDoCardState createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {
  bool _addNew;
  final _textController = TextEditingController();

  void _addNewItem() {
    widget.toDoGroup.add(Todo(_textController.value.text));
    _resetTextField();
  }

  void _resetTextField() {
    _textController.clear();
    setState(() {
      this._addNew = false;
    });
  }

  void _removeItem(Todo item) {
    setState(() {
      widget.toDoGroup.remove(item);
    });
  }

  @override
  void initState() {
    _addNew = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final caption = Container(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // the caption
          Row(
            children: [
              Container(
                child: Text(
                  widget.toDoGroup.title,
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
            onPressed: () => setState(() => _addNew = true),
          ),
          /*TabButton(
            title: 'add',
            icon: CustomIcons.add,
            onPressed: () => setState(() => _addNew = true),
          ),*/
        ],
      ),
    );

    final listLength = widget.toDoGroup.toDos.length;

    final todoList = Column(
      children: List.generate(_addNew ? listLength + 1 : listLength, (index) {
        return index != listLength
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.toDoGroup.toDos[index].title,
                    style: AppTheme.cardTextStyle,
                  ),
                  IconButton(
                    onPressed: () => _removeItem(widget.toDoGroup.toDos[index]),
                    icon: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.lightGrey, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      width: 18,
                      height: 18,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    //width: 150,
                    child: TextField(
                      controller: _textController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'wha\'ever',
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.clear),
                      color: Colors.red,
                      onPressed: _resetTextField),
                  IconButton(
                    icon: Icon(Icons.done),
                    color: Colors.blue,
                    onPressed: _addNewItem,
                  ),
                ],
              );
      }),
    );

    final body = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        child: todoList,
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: context.theme.primaryColor,
              width: 16,
            ),
            right: BorderSide(width: 0, color: Colors.transparent),
            top: BorderSide(width: 0, color: Colors.transparent),
            bottom: BorderSide(width: 0, color: Colors.transparent),
          ),
          color: AppColors.backgroundGrey,
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [caption, body],
      ),
    );
  }
}
