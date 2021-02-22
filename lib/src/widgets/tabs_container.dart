import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lists/src/app_settings.dart';
import 'package:lists/src/model/todo_list.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/service/DBProvider.dart';
import 'package:lists/src/strings.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/modals/add_new_list.dart';
import 'package:lists/src/widgets/modals/add_new_tab.dart';
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
  final _tabKeys = List<GlobalKey<TabWidgetState>>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isFabVisible = true;

  AppSettings settings;

  TabController _tabController;

  /// Return the active tab/
  /// Can be called only AFTER the state was initialized
  TodoTab get _activeTab => widget.tabs[_tabController.index];

  int get _activeTabIndex => widget.tabs.indexOf(_activeTab);

  @override
  void initState() {
    if (widget.tabs == null || widget.tabs.length == 0)
      print('there is a problem here');

    AppSettings.instance.load();
    final initialIndex = AppSettings.instance.lastOpenedTab < widget.tabs.length
        ? AppSettings.instance.lastOpenedTab
        : widget.tabs.length - 1;

    widget.tabs.forEach((_) => _tabKeys.add(GlobalKey<TabWidgetState>()));

    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: initialIndex,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging)
        AppSettings.instance.lastOpenedTab = _tabController.index;
    });

    AppSettings.instance.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  void addTab(TodoTab tab) {
    _tabKeys.add(GlobalKey<TabWidgetState>());
    setState(() {
      widget.tabs.add(tab);
      _tabController.dispose();
      _tabController = TabController(length: widget.tabs.length, vsync: this);
    });

    _tabController.animateTo(widget.tabs.length - 1);
  }

  Future deleteTab() async {
    final controllerIndex = _tabController.index;
    assert(controllerIndex == _activeTabIndex);
    final tabIndex = _activeTabIndex;
    bool delete = true;
    final duration = Duration(seconds: 4);

    final dialogAnswer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${Strings.deleteTab} ${_activeTab.title}?'),
        actions: [
          TextButton(
            // cancel button
            child: Text(Strings.cancel),
            onPressed: () => Navigator.of(context).pop<bool>(false),
          ),
          ElevatedButton(
            child: Text(Strings.delete),
            onPressed: () => Navigator.of(context).pop<bool>(true),
          ),
        ],
      ),
    ); // showDialog()

    if (dialogAnswer != true) return;

    final tabKey = _tabKeys[tabIndex];
    final tab = _activeTab;

    final snackBar = SnackBar(
      content: Row(
        children: [
          Text(Strings.deletedTab + ' '),
          Text(_activeTab.title, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      duration: duration,
      action: SnackBarAction(
        label: Strings.undo,
        onPressed: () {
          delete = false;
          setState(() {
            widget.tabs.insert(tabIndex, tab);
            _tabKeys.insert(tabIndex, tabKey);
            _tabController.dispose();
            _tabController = TabController(
              length: widget.tabs.length,
              vsync: this,
              initialIndex: tabIndex,
            );
          });
        },
      ),
    );

    setState(() {
      _tabKeys.removeAt(tabIndex);
      widget.tabs.removeAt(tabIndex);
      _tabController.dispose();
      _tabController = TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: widget.tabs.length - 1);
    });

    _scaffoldKey.currentState.showSnackBar(snackBar);

    Future.delayed(duration, () {
      if (delete) DBProvider.deleteTab(tab.id);
    });
  } // deleteTab

  void showFab() {
    if (_isFabVisible == false)
      setState(() {
        _isFabVisible = true;
      });
  }

  void hideFab() {
    if (_isFabVisible == true)
      setState(() {
        _isFabVisible = false;
      });
  } // hideFab

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
                        style: TextStyle(color: theme.accentColor),
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
        color: theme.primaryColor,
        borderRadius: borderRadius,
      ),
      unselectedLabelColor: theme.primaryColor,
    );

    final fabChildLabeStyle = TextStyle(
      color: mediaQuery.platformBrightness == Brightness.light
          ? Colors.black
          : Colors.white,
      fontSize: 16,
    );
    print(theme.brightness);

    final fab = SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.clear,
      tooltip: 'Add Something',
      curve: Curves.bounceIn,
      backgroundColor: theme.primaryColor,
      foregroundColor: Colors.white,
      children: [
        // add tab button
        SpeedDialChild(
          child: Icon(Icons.tab),
          label: Strings.tab,
          backgroundColor: theme.accentColor,
          labelStyle: fabChildLabeStyle,
          onTap: () async {
            final tab = await showModalBottomSheet(
              context: context,
              builder: (_) => AddNewTab(),
            );
            if (tab != null) addTab(tab);
          },
        ),
        // add list button
        SpeedDialChild(
          child: Icon(Icons.list),
          label: Strings.list,
          backgroundColor: theme.accentColor,
          labelStyle: fabChildLabeStyle,
          onTap: () async {
            final list = await showModalBottomSheet(
              context: context,
              builder: (_) => AddNewList(tabId: _activeTab.id),
            );

            if (list != null)
              _tabKeys[_activeTabIndex].currentState.addList(list);
          },
        )
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppTabBar(
        tabBar: tabBar,
        height: appBarHeight,
      ),
      body: TabBarView(
        children: widget.tabs
            .map(
              (tab) => TabWidget(
                tab: tab,
                key: _tabKeys[widget.tabs.indexOf(tab)],
              ),
            )
            .toList(),
        controller: _tabController,
      ),
      floatingActionButton: Visibility(
        visible: _isFabVisible,
        child: fab,
      ),
    );
  }
}
