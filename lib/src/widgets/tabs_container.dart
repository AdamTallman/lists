import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/service/sqflite.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/tab_widget.dart';
import 'package:lists/src/widgets/app_tab_bar.dart';

class TabsContaiter extends StatefulWidget {
  final List<TodoTab> tabs;
  TabsContaiter({@required this.tabs});

  @override
  TabsContaiterState createState() => TabsContaiterState();

  static TabsContaiterState of(BuildContext context) {
    final tabsContainer = context.findAncestorStateOfType<TabsContaiterState>();
    assert(() {
      if (tabsContainer == null)
        throw FlutterError('Somethins is reaaly wrong here');
      return true;
    }());

    return tabsContainer;
  }
}

class TabsContaiterState extends State<TabsContaiter>
    with TickerProviderStateMixin {
  static const double appBarHeight = 75.0;

  TabController _tabController;

  @override
  void initState() {
    if (widget.tabs == null || widget.tabs.length == 0)
      print('there is a problem here');

    _tabController = TabController(length: widget.tabs.length, vsync: this);
    super.initState();
  }

  void addTab(TodoTab tab) {
    setState(() {
      widget.tabs.add(tab);
      _tabController.dispose();
      _tabController = TabController(length: widget.tabs.length, vsync: this);
    });

    _tabController.animateTo(widget.tabs.length - 1);
  }

  Future deleteTab() async {
    final controllerIndex = _tabController.index;
    final activeTab = widget.tabs[controllerIndex];
    final tabIndex = widget.tabs.indexOf(activeTab);
    bool delete = true;
    final duration = Duration(seconds: 4);

    final dialogAnswer = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Delete tab ${activeTab.title}?'),
        actions: [
          TextButton(
            // cancel button
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop<bool>(false),
          ),
          ElevatedButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop<bool>(true),
          ),
        ],
      ),
    ); // showDialog()

    if (dialogAnswer == false) return;

    final snackBar = SnackBar(
      content: Row(
        children: [
          Text('Tab "'),
          Text(activeTab.title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text('" was deleted.')
        ],
      ),
      duration: duration,
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          delete = false;
          setState(() {
            widget.tabs.insert(tabIndex, activeTab);
            _tabController.dispose();
            _tabController = TabController(
              length: widget.tabs.length,
              vsync: this,
              initialIndex: controllerIndex,
            );
          });
        },
      ),
    );

    setState(() {
      final position = widget.tabs.indexOf(activeTab);
      widget.tabs.removeAt(position);
      _tabController.dispose();
      _tabController = TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: widget.tabs.length - 1);
    });

    context.scaffold.showSnackBar(snackBar);

    Future.delayed(duration, () {
      if (delete) DBProvider.instance.deleteTab(activeTab.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);

    final tabBar = TabBar(
      tabs: widget.tabs
          .map(
            (tab) => Tab(
              child: Row(
                children: [
                  Text(tab.title),
                  if (tab.todosCount != 0)
                    Container(
                      margin: EdgeInsets.only(left: 4),
                      child: Text(
                        tab.todosCount.toString(),
                        style: TextStyle(color: context.theme.accentColor),
                      ),
                    ),
                ],
              ),
            ),
          )
          .toList(),
      controller: _tabController,
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        color: context.theme.primaryColor,
        borderRadius: borderRadius,
      ),
      unselectedLabelColor: context.theme.primaryColor,
    );

    return Scaffold(
      appBar: AppTabBar(
        tabBar: tabBar,
        height: appBarHeight,
      ),
      body: TabBarView(
        children: widget.tabs
            .map((tab) => TabWidget(
                  tab: tab,
                ))
            .toList(),
        controller: _tabController,
      ),
    );
  }
}
