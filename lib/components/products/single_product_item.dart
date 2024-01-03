import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/controllers/wishlist_controller.dart';
import 'package:meqamax/pages/ecommerce/single_product.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/image.dart';
import 'package:meqamax/widgets_extra/navigator.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';
import 'package:meqamax/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SingleProductItem extends StatefulWidget {
  final Map data;
  const SingleProductItem({super.key, required this.data});

  @override
  State<SingleProductItem> createState() => _SingleProductItemState();
}

class _SingleProductItemState extends State<SingleProductItem> {
  bool loading = false;

  final wishlistController = Get.put(WishlistController());
  final loginController = Get.put(LoginController());
  final box = GetStorage();

  addWishlsit(productId) async {
    setState(() {
      loading = true;
    });
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/wishlist.php?action=update&product_id=$productId&session_key=${loginController.userId.value}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              box.write('update', false);
              wishlistController.update(result['result']['list']);
            });
          } else {
            setState(() {
              loading = false;
              showSnackBar(context, result['error']);
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget stockWidget = SizedBox();

    if (widget.data['stock'] == '0') {
      stockWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Text(
          'Bitib'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      );
    } else if (widget.data['stock'] != '' && widget.data['stock'] != null && int.parse(widget.data['stock']) <= 5) {
      stockWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: Text(
          'product_stock'.trParams({
            'count': widget.data['stock'],
          }),
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        navigatePage(context, SingleProductPage(data: widget.data));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          color: Theme.of(context).colorScheme.secondaryBg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 2 / 2.5,
                    child: MsImage(
                      url: widget.data['thumbnail_url'],
                      pSize: 50.0,
                      pBackgroundColor: Theme.of(context).colorScheme.grey4,
                      pColor: Theme.of(context).colorScheme.grey2,
                    ),
                  ),
                  Positioned(
                    right: 7.0,
                    top: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        addWishlsit(widget.data['post_id']);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryBg,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Obx(() => (loading)
                              ? SizedBox(
                                  width: 18.0,
                                  height: 18.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    backgroundColor: Theme.of(context).colorScheme.bg,
                                  ),
                                )
                              : (wishlistController.wishlist.contains(int.parse(widget.data['post_id'])))
                                  ? MsSvgIcon(
                                      icon: 'assets/navigations/bold-favorite.svg',
                                      size: 18.0,
                                      color: Theme.of(context).colorScheme.primaryColor,
                                    )
                                  : MsSvgIcon(
                                      icon: 'assets/navigations/favorite.svg',
                                      size: 18.0,
                                      color: Theme.of(context).colorScheme.text,
                                    ))),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 10.0,
                    child: stockWidget,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['post_title'],
                      maxLines: 2,
                      style: Theme.of(context).textTheme.extraSmallHeading,
                    ),
                    SizedBox(height: 10.0),
                    displayPrice(widget.data, range: (widget.data['product_type'] == 'variable') ? true : false)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
