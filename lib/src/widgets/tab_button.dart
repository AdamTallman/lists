import 'package:flutter/material.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/utils/context.dart';
import 'package:lists/src/widgets/custom_icon.dart';

class TabButton extends StatelessWidget {
  final String icon;
  final String title;
  final Function onPressed;
  final bool active;

  TabButton({this.icon, this.title, this.onPressed, this.active = false});

  @override
  Widget build(BuildContext context) {
    /*final button = ColorFiltered(
      child: icon,
      colorFilter: ColorFilter.mode(
          active ? context.theme.primaryColor : AppColors.backgroundGrey,
          BlendMode.color),
    );*/

    final ic = CustomIcon(
      icon,
      color: active ? context.theme.primaryColor : AppColors.backgroundGrey,
    );

    final activeButton = Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          ic,
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: TextStyle(
                  color: context.theme.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ),
        ],
      ),
    );

    return RaisedButton(
      onPressed: onPressed,
      elevation: 0,
      shape: active
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))
          : CircleBorder(),
      color: active ? AppColors.backgroundGrey : Colors.transparent,
      padding: EdgeInsets.all(8),
      child: Container(
        child: active ? activeButton : ic,
      ),
    );
  }
}
