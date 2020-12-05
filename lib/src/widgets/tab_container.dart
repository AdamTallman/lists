import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/tab_button.dart';
import 'package:lists/src/widgets/todo/todo_card.dart';

class TabsContaiter extends StatefulWidget {
  final List<ToDoTab> tabs;

  TabsContaiter({this.tabs});

  @override
  _TabsContaiterState createState() => _TabsContaiterState();
}

class _TabsContaiterState extends State<TabsContaiter> {
  ToDoTab _activeTab;
  final double appBarHeight = 75.0;
  @override
  void initState() {
    if (widget.tabs.isNotEmpty) _activeTab = widget.tabs[0];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _tabs = widget.tabs;
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
                    onPressed: () {},
                  ),
                );
              },
            ),
          ),
          // the menu button for future
          /*IconButton(
            icon: Icon(Icons.more_vert),
            color: context.theme.primaryColor,
            onPressed: () {},
          ),*/
        ],
      ),
    ); // tabBar
    final addListButton = OutlinedButton(
      onPressed: () {},
      child: Text('Add List'),
    );

    final body = Container(
      margin:
          EdgeInsets.only(top: appBarHeight + context.mediaQuery.padding.top),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: _activeTab.toDoGroups.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.all(1),
              scrollDirection: Axis.vertical,
              itemCount: _activeTab.toDoGroups.length + 1,
              itemBuilder: (ctx, index) => index == _activeTab.toDoGroups.length
                  ? addListButton
                  : ToDoCard(_activeTab.toDoGroups[index]),
            )
          : Text('fuck you'),
    );

    return Stack(
      children: [tabBar, body],
    );

    Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          tabBar,
          Text('what the fuck'),
          Container(child: body),
          OutlineButton(
            onPressed: () {},
            child: Text('Add List'),
          )
        ],
      ),
    );
  }
}
