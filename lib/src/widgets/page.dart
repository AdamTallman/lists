import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/service/sqflite.dart';
import 'package:lists/src/widgets/tabs_container.dart';

class PageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TodoTab>>(
        future: DBProvider.instance.getTabs(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Center(child: Text('oh shit'));
          if (snapshot.connectionState == ConnectionState.done)
            return TabsContaiter(tabs: snapshot.data);

          return Center(child: CircularProgressIndicator());
        });
  }
}
