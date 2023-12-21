import 'package:flutter/material.dart';

void navigatePage(BuildContext context, Widget screen, {root = false}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  Navigator.of(context, rootNavigator: root).push(
    MaterialPageRoute(
      builder: (context) => screen,
      maintainState: false,
    ),
  );
}
