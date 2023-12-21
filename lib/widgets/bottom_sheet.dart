import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';

class MsBottomSheet extends StatelessWidget {
  const MsBottomSheet({
    super.key,
    required this.child,
    this.color,
  });

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        color: (color != null) ? color : Theme.of(context).colorScheme.secondaryBg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 7.0),
          Ink(
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.grey3, borderRadius: BorderRadius.circular(10.0)),
          ),
          SizedBox(height: 5.0),
          child,
        ],
      ),
    );
  }
}
