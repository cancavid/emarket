import 'package:flutter/material.dart';
import 'package:meqamax/widgets/bottom_sheet_liner.dart';

class MsBottomSheet extends StatelessWidget {
  final double? linerHeight;
  final Widget child;
  const MsBottomSheet({super.key, required this.child, this.linerHeight});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.none,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MsBottomSheetLiner(height: linerHeight),
          child,
        ],
      ),
    );
  }
}
