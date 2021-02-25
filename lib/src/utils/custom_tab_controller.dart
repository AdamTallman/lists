import 'package:flutter/material.dart';

class CustomTabController extends TabController {
  CustomTabController(
      {int initialIndex = 0,
      @required int length,
      @required TickerProvider vsync})
      : super(initialIndex: initialIndex, length: length, vsync: vsync);

  void updateLength(int newLength) {}
}
