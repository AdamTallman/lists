import 'package:flutter/material.dart';
import 'package:lists/src/styles.dart';
import 'package:lists/src/utils/context.dart';

class TodoWidget extends StatelessWidget {
  final String title;
  final Function onDone;

  TodoWidget({@required this.title, @required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        onTap: onDone,
        title: Text(
          title,
          style: AppTheme.cardTextStyle,
        ),
        trailing: IconButton(
          onPressed: onDone,
          icon: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            width: 18,
            height: 18,
          ),
        ),
      ),
    );
  }
}
