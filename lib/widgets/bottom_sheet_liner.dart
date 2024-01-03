import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';

class MsBottomSheetLiner extends StatelessWidget {
  final double? height;
  const MsBottomSheetLiner({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.pop(context);
          },
          child: SizedBox(
            height: height ?? 30.0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 40.0,
                height: 4.0,
                margin: const EdgeInsets.only(top: 5.0),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.grey3, borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
