import 'package:flutter/material.dart';
import 'package:lists/src/strings.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/pages/settings_page.dart';
import 'package:lists/src/widgets/tabs_container.dart';

class AppTabBar extends StatelessWidget with PreferredSizeWidget {
  final TabBar tabBar;
  final double height;
  final ScrollController controller;

  @override
  Size get preferredSize => Size.fromHeight(height);
  AppTabBar({@required this.tabBar, this.height, this.controller});

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
            child: Row(
              children: [
                Icon(Icons.delete, size: 20),
                SizedBox(width: 16),
                Text(Strings.deleteTab),
              ],
            ),
            value: 1,
          ),
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.settings, size: 20),
                SizedBox(width: 16),
                Text(Strings.settings),
              ],
            ),
            value: 2,
          ),
        ];
      },
      onSelected: (val) {
        switch (val) {
          case 1:
            _deleteTab(context);
            break;
          case 2:
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SettingsPage()));
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

            menuButton,
          ],
        ),
      ),
    ]);
  }
}
