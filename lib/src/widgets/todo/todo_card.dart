import 'package:flutter/material.dart';
import 'package:lists/src/model/todo_group.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/widgets/custom_icon.dart';
import 'package:lists/src/widgets/tab_button.dart';
import 'package:lists/src/utils/context.dart';

class ToDoCard extends StatelessWidget {
  final ToDoGroup toDoGroup;

  ToDoCard(this.toDoGroup);

  @override
  Widget build(BuildContext context) {
    final caption = Container(
      padding: EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // the caption
          Container(
            child: Text(
              toDoGroup.title,
              style: context.theme.textTheme.headline6
                  .apply(color: context.theme.primaryColor),
            ),
          ),
          TabButton(
            title: 'add',
            icon: CustomIcons.add,
            onPressed: () {},
          ),
        ],
      ),
    );

    final todoList = Column(
      children: List.generate(toDoGroup.toDos.length, (index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(toDoGroup.toDos[index].title),
            TabButton(
              title: '',
              icon: CustomIcons.add,
            ),
          ],
        );
      }),
    );

    final body = Stack(
      children: [
        Container(
          width: 16,
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
        ),
        //main container
        Container(
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: todoList,
        ),
      ],
    );

    return Container(
      child: Column(
        children: [caption, body],
      ),
    );
  }
}
