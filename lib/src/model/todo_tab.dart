// src/model/todo_tab.dart

import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_list.dart';

class ToDoTab {
  final String icon;
  final String title;
  final bool active;
  final List<TodoList> toDoGroups;

  ToDoTab(this.title, {this.icon, this.toDoGroups, this.active = false});
}
