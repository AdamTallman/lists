import 'package:flutter/material.dart';
import 'package:fdottedline/fdottedline.dart';

class DashedButton extends StatelessWidget {
  final Color color;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final Key key;

  DashedButton(
      {@required this.child,
      this.color,
      this.padding = EdgeInsets.zero,
      this.key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(child: FDottedLine());
  }
}
