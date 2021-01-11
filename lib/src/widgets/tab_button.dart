import 'package:flutter/material.dart';
import 'package:lists/src/utils/context.dart';

class TabButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool isActive;
  final Color color;

  TabButton({this.title, this.onPressed, this.color, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return isActive
        ? ElevatedButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
          )
        : TextButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 15,
              ),
            ),
            style: TextButton.styleFrom(
              primary: context.theme.primaryColor,
            ),
          );
  }
}
