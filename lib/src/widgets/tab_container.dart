import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lists/src/model/todo.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/tab_button.dart';
import 'package:lists/src/widgets/todo/add_list.dart';
import 'package:lists/src/widgets/todo/todo_card.dart';

class TabsContaiter extends StatefulWidget {
  final List<ToDoTab> tabs;

  TabsContaiter({this.tabs});

  @override
  _TabsContaiterState createState() => _TabsContaiterState();
}

class _TabsContaiterState extends State<TabsContaiter> {
  ToDoTab _activeTab;
  static const double appBarHeight = 75.0;

  @override
  void initState() {
    if (widget.tabs.isNotEmpty) _activeTab = widget.tabs[0];
    super.initState();
  }

  void _addList(String title) {
    if (title != null && title.isNotEmpty)
      setState(() {
        _activeTab.toDoGroups.add(TodoList(title, toDos: []));
      });
  }

  void _setTab(int index) {
    if (index < widget.tabs.length && index != widget.tabs.indexOf(_activeTab))
      setState(() {
        _activeTab = widget.tabs[index];
      });
  }

  @override
  Widget build(BuildContext context) {
    final _tabs = widget.tabs;

    final banner = Container(
      height: context.mediaQuery.padding.top,
      decoration: BoxDecoration(color: context.theme.primaryColor),
    );

    final tabBar = Container(
      height: appBarHeight,
      margin: EdgeInsets.only(top: context.mediaQuery.padding.top),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // the tabs
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              itemBuilder: (ctx, index) {
                return Container(
                  child: TabButton(
                    icon: _tabs[index].icon,
                    title: _tabs[index].title,
                    active: _activeTab == _tabs[index],
                    onPressed: () => _setTab(index),
                  ),
                );
              },
            ),
          ),
          // the menu button for future
          IconButton(
            icon: Icon(Icons.more_vert),
            color: context.theme.primaryColor,
            onPressed: () {},
          ),
        ],
      ),
    ); // tabBar

    final addListButton = AddList(_addList);

    final body = Container(
      margin: EdgeInsets.only(
          top: appBarHeight + context.mediaQuery.padding.top,
          left: 8,
          right: 8),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: _activeTab.toDoGroups.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.only(bottom: 8),
              scrollDirection: Axis.vertical,
              itemCount: _activeTab.toDoGroups.length + 1,
              itemBuilder: (ctx, index) => index == _activeTab.toDoGroups.length
                  ? addListButton
                  : ToDoCard(_activeTab.toDoGroups[index]),
            )
          : ListView(
              children: [
                Text('Nothing here yet',
                    style: TextStyle(color: AppColors.backgroundGrey)),
                addListButton,
              ],
            ),
    );

    return Stack(
      children: [banner, tabBar, body],
    );
  }
}
