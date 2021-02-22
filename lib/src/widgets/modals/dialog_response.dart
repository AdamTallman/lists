import 'package:flutter/widgets.dart';

enum DialogAnswer {
  ok,
  delete,
  cancel,
}

class DialogResponse<T> {
  final DialogAnswer answer;
  final T value;

  DialogResponse({@required this.answer, this.value});
}
