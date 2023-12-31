import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/components/single_product/comments.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/rating.dart';

class SingleProductTitle extends StatefulWidget {
  final Map data;
  const SingleProductTitle({super.key, required this.data});

  @override
  State<SingleProductTitle> createState() => _SingleProductTitleState();
}

class _SingleProductTitleState extends State<SingleProductTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Theme.of(context).colorScheme.secondaryBg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data['post_title'],
                style: Theme.of(context).textTheme.smallHeading,
              ),
              SizedBox(height: 5.0),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ProductComments(id: widget.data['post_id'].toString());
                      });
                },
                child: Row(
                  children: [
                    MsRating(value: double.parse(widget.data['rating'].toString())),
                    SizedBox(width: 7.0),
                    Text(
                        'single_product_rating'.trParams({
                          'rating': widget.data['rating'].toString(),
                          'count': widget.data['commentsCount'].toString(),
                        }),
                        style: Theme.of(context).textTheme.extraSmallTitle),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              displayPrice(widget.data, type: 'Large'),
            ],
          ),
          if (widget.data['stock'] == '0') ...[
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(3.0)),
              child: Text(
                'Məhsul bitib'.tr,
                style: TextStyle(color: Colors.white, fontSize: 12.0, height: 1.2),
              ),
            )
          ] else if (widget.data['stock'] != '' && widget.data['stock'] != null && int.parse(widget.data['stock']) <= 5) ...[
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(3.0)),
              child: Text(
                'product_stock'.trParams({
                  'count': widget.data['stock'],
                }),
                style: TextStyle(color: Colors.white, fontSize: 12.0, height: 1.2),
              ),
            )
          ]
        ],
      ),
    );
  }
}
