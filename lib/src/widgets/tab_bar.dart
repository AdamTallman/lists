import 'package:flutter/material.dart';
import 'package:lists/src/widgets/custom_icon.dart';
import 'package:lists/src/widgets/tab_button.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/add_new_tab.dart';

class TabBarWidget extends StatelessWidget {
  final List<TabButton> buttons;
  final double height;

  TabBarWidget({@required this.buttons, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(top: context.mediaQuery.padding.top),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // the tabs
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              children: buttons,
            ),
          ),
          // add new tab
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: context.theme.primaryColor,
              size: 32,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  } // build

  void _showAddTab(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) => AddNewTab());
  }
}
