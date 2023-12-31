import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';

class MsBottomSheetLiner extends StatelessWidget {
  const MsBottomSheetLiner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40.0,
          height: 4.0,
          margin: const EdgeInsets.only(top: 5.0),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.grey3, borderRadius: BorderRadius.circular(10.0)),
        ),
      ],
    );
  }
}
