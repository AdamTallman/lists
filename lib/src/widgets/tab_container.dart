import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/tab.dart';
import 'package:lists/src/widgets/tab_bar.dart';
import 'package:lists/src/widgets/tab_button.dart';

class TabsContaiter extends StatefulWidget {
  final List<TodoTab> tabs;
  TabsContaiter({@required this.tabs});

  @override
  _TabsContaiterState createState() => _TabsContaiterState();
}

class _TabsContaiterState extends State<TabsContaiter> {
  TodoTab _activeTab;
  static const double appBarHeight = 75.0;

  @override
  void initState() {
    if (widget.tabs == null || widget.tabs.length == 0)
      print('there is a problem here');
    else
      _activeTab = widget.tabs[0];

    super.initState();
  }

  void _setTab(int index) {
    if (index < widget.tabs.length && index != widget.tabs.indexOf(_activeTab))
      setState(() {
        _activeTab = widget.tabs[index];
      });
  }

  void _scrollTab(DragUpdateDetails details) {
    int tabIndex = widget.tabs.indexOf(_activeTab);
    if (details.delta.dx < 0) {
      //swipe right
      if (tabIndex < widget.tabs.length - 1)
        setState(() {
          _activeTab = widget.tabs[tabIndex + 1];
        });
    }
    if (details.delta.dx > 0) {
      // swipe left
      if (tabIndex > 0)
        setState(() {
          _activeTab = widget.tabs[tabIndex - 1];
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final banner = Container(
      height: context.mediaQuery.padding.top,
      decoration: BoxDecoration(color: context.theme.primaryColor),
    );

    final tabBar = TabBarWidget(
      height: appBarHeight,
      buttons: List.generate(
        widget.tabs.length,
        (index) => TabButton(
          icon: widget.tabs[index].icon,
          title: widget.tabs[index].title,
          active: _activeTab == widget.tabs[index],
          onPressed: () => _setTab(index),
        ),
      ),
    );

    return Stack(
      children: [
        banner,
        tabBar,
        GestureDetector(
          onPanUpdate: _scrollTab,
          child: TabWidget(
            tab: _activeTab,
            paddingTop: appBarHeight + context.mediaQuery.padding.top,
          ),
        )
      ],
    );
  }
}
