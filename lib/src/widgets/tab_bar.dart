import 'package:flutter/material.dart';
import 'package:lists/src/widgets/tab_button.dart';
import 'package:lists/src/utils/context.dart';

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
          // the menu button for future
          IconButton(
            icon: ClipOval(
              child: Container(
                color: context.theme.primaryColor,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
