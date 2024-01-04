import 'package:flutter/material.dart';

class MsScrollableWidget extends StatelessWidget {
  final Widget child;
  const MsScrollableWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100.0,
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }
}
