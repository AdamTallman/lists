import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/service/sqflite.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/widgets/todo/add_list.dart';
import 'package:lists/src/widgets/todo/todo_card.dart';
import 'package:lists/src/utils/context.dart';

class TabWidget extends StatefulWidget {
  final TodoTab tab;
  final double paddingTop;

  TabWidget({this.tab, this.paddingTop});

  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  void _addList(String title) async {
    if (title != null && title.isNotEmpty) {
      int id = await DBProvider.instance.addList(title, widget.tab.id);
      context.scaffold.showSnackBar(SnackBar(
        content: Text('New list has been added'),
      ));
      setState(() {
        widget.tab.todoLists.add(TodoList(title, id: id, todos: []));
      });
    }
  }

  void _deleteList(int id) async {
    final list = widget.tab.todoLists.singleWhere((list) => list.id == id);
    final listIndex = widget.tab.todoLists.indexOf(list);
    final duration = Duration(seconds: 4);
    bool delete = true;

    final snackBar = SnackBar(
      duration: duration,
      content: Row(
        children: [
          Text('List "'),
          Text(list.title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text('" was deleted.'),
        ],
      ),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          delete = false;
          setState(() {
            widget.tab.todoLists.insert(listIndex, list);
          });
        },
      ),
    );

    setState(() {
      widget.tab.todoLists.remove(list);
    });

    context.scaffold.showSnackBar(snackBar);

    Future.delayed(duration, () {
      if (delete) DBProvider.instance.deleteList(id);
    });
  }

  @override
  Widget build(context) {
    final addListButton = AddListButton(_addList);

    final listsContainer = widget.tab == null
        ? Center(
            child: Text("Something is not okay"),
          )
        : widget.tab.todoLists.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 8),
                scrollDirection: Axis.vertical,
                itemCount: widget.tab.todoLists.length + 1,
                itemBuilder: (ctx, index) =>
                    index == widget.tab.todoLists.length
                        ? addListButton
                        : ToDoCard(
                            todoList: widget.tab.todoLists[index],
                            onDelete: _deleteList,
                          ),
              )
            : ListView(
                children: [
                  Text('Nothing here yet',
                      style: TextStyle(color: AppColors.backgroundGrey)),
                  addListButton,
                ],
              );

    final body = Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: listsContainer,
    );

    return body;
  }
}
