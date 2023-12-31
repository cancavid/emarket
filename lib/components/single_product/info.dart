import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/bottom_sheet_liner.dart';
import 'package:meqamax/widgets/html.dart';
import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  final String data;
  const ProductInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MsBottomSheetLiner(),
        Expanded(
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
      ],
    );
  }
}
