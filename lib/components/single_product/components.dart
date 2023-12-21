import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/components/single_product/comments.dart';
import 'package:meqamax/components/single_product/component.dart';
import 'package:meqamax/components/single_product/delivery.dart';
import 'package:meqamax/components/single_product/info.dart';
import 'package:meqamax/themes/theme.dart';

class SingleProductComponents extends StatelessWidget {
  final Map data;
  const SingleProductComponents({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        color: Theme.of(context).colorScheme.bg,
        child: IntrinsicHeight(
          child: Row(
            children: [
              SingleProductComponent(
                  icon: 'assets/interface/info.svg',
                  title: 'Məhsul haqqında'.tr,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ProductInfo(data: data['post_content']);
                        });
                  }),
              SizedBox(width: 5.0),
              SingleProductComponent(
                  icon: 'assets/interface/comment.svg',
                  title: 'Müştəri rəyləri'.tr,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ProductComments(id: data['post_id'].toString());
                        });
                  }),
              SizedBox(width: 5.0),
              SingleProductComponent(
                  icon: 'assets/interface/shipping.svg',
                  title: 'Çatdırılma şərtləri'.tr,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return DeliveryInfo(data: data['post_content']);
                        });
                  })
            ],
          ),
        ));
  }
}
