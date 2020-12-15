import 'package:flutter/material.dart';
import 'package:lists/src/utils/context.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final Color color;
  final Function onPressed;

  CustomIconButton({@required this.icon, this.color, @required this.onPressed});

  @override
  Widget build(BuildContext condext) {
    return MaterialButton(
      shape: CircleBorder(),
      onPressed: onPressed,
      child: icon,
      padding: EdgeInsets.all(8),
    );
  }
}
