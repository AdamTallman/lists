import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lists/src/app_settings.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/service/DBProvider.dart';
import 'package:lists/src/strings.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/modals/add_new_list.dart';
import 'package:lists/src/widgets/modals/add_new_tab.dart';
import 'package:lists/src/widgets/tab_widget.dart';
import 'package:lists/src/widgets/app_tab_bar.dart';

class TabContaiter extends StatefulWidget {
  final List<TodoTab> tabs;
  TabContaiter({@required this.tabs});

  @override
  TabContaiterState createState() => TabContaiterState();

  static TabContaiterState of(BuildContext context) {
    final tabsContainer = context.findAncestorStateOfType<TabContaiterState>();
    assert(() {
      if (tabsContainer == null)
        throw FlutterError('Somethins is reaaly wrong here');
      return true;
    }());

    return tabsContainer;
  }
}

class TabContaiterState extends State<TabContaiter>
    with TickerProviderStateMixin {
  /// The keys of the tabs that tha widget holds.
  final _tabKeys = List<GlobalKey<TabWidgetState>>();

  /// The [Scaffold]'s key, used
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// The visibility of the [FloatingActionButton].
  bool _isFabVisible = true;

  AppSettings settings;

  TabController _tabController;

  /// Returns the active tab.
  ///
  /// Can be called only AFTER the state was initialized.
  TodoTab get _activeTab => widget.tabs[_tabController.index];

  /// The index of the active tab in the [TabContoller].
  int get _activeTabIndex => widget.tabs.indexOf(_activeTab);

  @override
  void initState() {
    // TODO: deal with the 0 tabs
    if (widget.tabs == null || widget.tabs.length == 0)
      print('there is a problem here');

    // This is supposed to be loaded at this point, but just in case.
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

    // dont like this at all
    AppSettings.instance.addListener(() {
      //setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  /// Adds new tab to the container and navigates [TabController] to it.
  void _addTab(TodoTab tab) {
    _tabKeys.add(GlobalKey<TabWidgetState>());
    _tabController.dispose();

    setState(() {
      widget.tabs.add(tab);

      // TODO: this is shit. Gotta find a way without creating a new TabController
      // and registering a new Ticker
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
      );
      _tabController.animateTo(widget.tabs.length - 1);
    });
  }

  /// Deletes the current tab and navigates [TabController] to the last tab
  Future deleteTab() async {
    // TODO set controller to the previous tab after deletion
    final controllerIndex = _tabController.index;
    assert(controllerIndex == _activeTabIndex);
    final tabIndex = _activeTabIndex;
    bool delete = true;
    final duration = Duration(seconds: 4);

    // ask for confirmation
    final bool dialogAnswer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${Strings.deleteTab} ${_activeTab.title}?'),
        actions: [
          TextButton(
            // cancel button
            child: Text(Strings.cancel),
            onPressed: () => Navigator.of(context).pop<bool>(false),
          ),
          // delete button
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
      // Undo button. Returns the tab to the container and resets the tabController
      action: SnackBarAction(
        label: Strings.undo,
        onPressed: () {
          delete = false;
          _tabController.dispose();
          setState(() {
            widget.tabs.insert(tabIndex, tab);
            _tabKeys.insert(tabIndex, tabKey);
            _tabController = TabController(
              length: widget.tabs.length,
              vsync: this,
              initialIndex: tabIndex,
            );
          }); // setState()
        },
      ),
    );

    _tabController.dispose();
    setState(() {
      _tabKeys.removeAt(tabIndex);
      widget.tabs.removeAt(tabIndex);
      _tabController = TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: widget.tabs.length - 1);
    });

    // show the snackBar after deletion
    _scaffoldKey.currentState.showSnackBar(snackBar);

    // if the 'Undo' button wasn't pressed, delete the tab from database
    Future.delayed(duration, () {
      if (delete) DBProvider.deleteTab(tab.id);
    });
  } // deleteTab

  /// Makes the FAB visible.
  void showFab() {
    if (_isFabVisible == false)
      setState(() {
        _isFabVisible = true;
      });
  }

  /// Makes the FAB invisible.
  void hideFab() {
    if (_isFabVisible == true)
      setState(() {
        _isFabVisible = false;
      });
  } // hideFab

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      tabs: widget.tabs
          .map((tab) => Tab(
                child: Row(
                  children: [
                    Text(tab.title),
                    if (tab.todosCount != 0) // todos counter
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: Text(
                          tab.todosCount.toString(),
                          style: TextStyle(color: theme.accentColor),
                        ),
                      ),
                  ],
                ),
              )) // .map(tab)
          .toList(),
      controller: _tabController,
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(20),
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
            // show AddNewTab modal form and wait for response
            final tab = await showModalBottomSheet(
              context: context,
              builder: (_) => AddNewTab(),
            );
            if (tab != null) _addTab(tab);
          },
        ),
        // add list button
        SpeedDialChild(
          child: Icon(Icons.list),
          label: Strings.list,
          backgroundColor: theme.accentColor,
          labelStyle: fabChildLabeStyle,
          onTap: () async {
            // show AddNewList modal form and wait for response
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
