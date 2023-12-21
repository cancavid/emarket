import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/components/products/single_product_item.dart';
import 'package:meqamax/pages/ecommerce/new_products.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/navigator.dart';

class HomeNewsProducts extends StatelessWidget {
  final List posts;
  const HomeNewsProducts({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return (posts.isEmpty)
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Yeni əlavə olunanlar'.tr, style: Theme.of(context).textTheme.extraLargeHeading),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigatePage(context, NewProductsPage());
                      },
                      child: Text('Hamısı', style: Theme.of(context).textTheme.link),
                    )
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
          );
  }
}
