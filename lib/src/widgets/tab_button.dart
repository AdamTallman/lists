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
    final custIcon = CustomIcon(
      icon,
      color: active ? context.theme.primaryColor : AppColors.backgroundGrey,
    );

    return active
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: custIcon,
            label: Text(
              title,
              style: TextStyle(
                  color: context.theme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: AppColors.backgroundGrey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
          )
        : IconButton(
            icon: custIcon,
            onPressed: onPressed,
          );
  }
}
