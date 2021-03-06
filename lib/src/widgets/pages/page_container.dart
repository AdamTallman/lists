import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_tab.dart';
import 'package:lists/src/service/DBProvider.dart';
import 'package:lists/src/widgets/tabs_container.dart';

class PageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TodoTab>>(
        future: DBProvider.getTabs(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Center(child: Text('oh shit'));
          if (snapshot.connectionState == ConnectionState.done)
            return TabContaiter(tabs: snapshot.data);

          return Center(child: CircularProgressIndicator());
        });
  }
}
