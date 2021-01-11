import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/add_new_tab.dart';
import 'package:lists/src/widgets/tabs_container.dart';

class AppTabBar extends StatelessWidget with PreferredSizeWidget {
  final TabBar tabBar;
  final double height;
  final ScrollController controller;

  @override
  Size get preferredSize => Size.fromHeight(height);
  AppTabBar({@required this.tabBar, this.height, this.controller});

  void _showAddTab(BuildContext context) async {
    final tab = await showModalBottomSheet<TodoTab>(
        context: context, builder: (_) => AddNewTab());
    if (tab != null) TabsContaiter.of(context).addTab(tab);

    //showBottomSheet(context: context, builder: (_) => AddNewTab());
  }

  Future _deleteTab(BuildContext context) async {
    await TabsContaiter.of(context).deleteTab();
  }

  @override
  Widget build(BuildContext context) {
    final banner = Container(
      height: context.mediaQuery.padding.top,
      decoration: BoxDecoration(color: context.theme.primaryColor),
    );

    final menuButton = PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: context.theme.primaryColor,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text('Delete Tab'),
            value: 1,
          ),
          PopupMenuItem(child: Text('Settings'), value: 2),
        ];
      },
      onSelected: (val) {
        switch (val) {
          case 1:
            _deleteTab(context);
            break;
        }
      },
    );

    return Stack(children: [
      banner,
      Container(
        height: height,
        margin: EdgeInsets.only(top: context.mediaQuery.padding.top),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // the tabs
            Expanded(
              child: tabBar,
            ),
            // add new tab
            IconButton(
              icon: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: context.theme.primaryColor),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                  //size: 32,
                ),
              ),
              onPressed: () => _showAddTab(context),
            ),
            menuButton,
          ],
        ),
      ),
    ]);
  }
}
