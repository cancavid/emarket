import 'package:flutter/material.dart';
import 'package:meqamax/components/products/load_products.dart';
import 'package:meqamax/themes/theme.dart';

class CampaignProducts extends StatelessWidget {
  final String? multiple;
  const CampaignProducts({super.key, required this.multiple});

  @override
  Widget build(BuildContext context) {
    return (multiple != null)
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child: Expanded(
                  child: Text('Kampaniyaya aid məhsullar', style: Theme.of(context).textTheme.extraLargeHeading),
                ),
              ),
              LoadProducts(
                multiple: multiple,
                physics: NeverScrollableScrollPhysics(),
              ),
            ],
          )
        : SizedBox();
  }
}
