import 'package:meqamax/widgets/bottom_sheet.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';

import 'package:meqamax/widgets/html.dart';
import 'package:flutter/material.dart';

class DeliveryInfo extends StatelessWidget {
  final String data;
  const DeliveryInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MsBottomSheet(
      child: Expanded(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
              MsHtml(data: data),
            ],
          ),
        ),
      ),
    );
  }
}
