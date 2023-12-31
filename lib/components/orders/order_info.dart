import 'package:get/get.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool copy;
  const OrderInfoItem({super.key, required this.label, required this.value, this.copy = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: Theme.of(context).textTheme.extraSmallTitle),
        SizedBox(width: 30.0),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              if (copy) {
                Clipboard.setData(ClipboardData(text: value));
                showSnackBar(context, 'Məlumat panoya kopyalandı.'.tr, type: SnackBarTypes.info);
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(value, style: Theme.of(context).textTheme.extraSmallHeading, textAlign: TextAlign.end),
                ),
                if (copy) ...[
                  SizedBox(width: 8.0),
                  Icon(
                    Icons.copy,
                    size: 16.0,
                    color: Theme.of(context).colorScheme.grey1,
                  ),
                ]
              ],
            ),
          ),
        ))
      ],
    );
  }
}
