import 'package:flutter/material.dart';

extension Context on BuildContext {
  ThemeData get theme => Theme.of(this);
  ScaffoldState get scaffold => Scaffold.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}

extension Contexts on State {
  ThemeData get theme => Theme.of(this.context);
  ScaffoldState get scaffold => Scaffold.of(this.context);
  MediaQueryData get mediaQuery => MediaQuery.of(this.context);
}
