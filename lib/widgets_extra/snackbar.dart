import 'package:flutter/material.dart';

enum SnackBarTypes { success, error, info }

void showSnackBar(BuildContext context, String message, {SnackBarTypes? type, SnackBarAction? action, Duration? duration}) {
  Color backgroundColor = Colors.red.shade700;

  if (type == SnackBarTypes.success) {
    backgroundColor = Colors.green;
  } else if (type == SnackBarTypes.info) {
    backgroundColor = Color(0xFF333333);
  }

  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: duration ?? Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        content: Text(message.replaceAll('<br>', '\n')),
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
}
