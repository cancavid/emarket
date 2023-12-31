import 'package:flutter/material.dart';
import 'package:meqamax/components/products/single_product_item.dart';
import 'package:meqamax/themes/theme.dart';

class CarouselProducts extends StatelessWidget {
  final String? title;
  final List posts;
  final EdgeInsets? padding;
  final Function()? action;
  const CarouselProducts({super.key, required this.posts, this.title, this.padding, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: (posts.isEmpty)
          ? SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                  child: Row(
                    children: [
                      if (title != null) ...[
                        Expanded(
                          child: Text(title!, style: Theme.of(context).textTheme.extraLargeHeading),
                        ),
                      ],
                      if (action != null) ...[
                        GestureDetector(
                          onTap: action,
                          child: Text('Hamısı', style: Theme.of(context).textTheme.link),
                        )
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  height: 300.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          (index == 0) ? SizedBox(width: 20.0) : SizedBox(),
                          SizedBox(width: 150.0, height: 300.0, child: SingleProductItem(data: posts[index])),
                          (index == posts.length - 1) ? SizedBox(width: 20.0) : SizedBox(),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(width: 15.0);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
