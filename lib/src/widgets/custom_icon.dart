import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String source;
  final Color color;

  CustomIcon(this.source, {this.color});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      source,
      color: color,
      width: 24,
      height: 24,
    );
  }
}

class CustomIcons {
  static const _prefix = 'assets/icons/';
  static const books = _prefix + 'books.png';
  static const add = _prefix + 'add.png';
  static const add_dark = _prefix + 'add_Dark.png';
  static const video = _prefix + 'video.png';
  static const todo = _prefix + 'todo.png';
  static const bag = _prefix + 'bag.png';
  static const edit = _prefix + 'edit.png';
}
