import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/components/products/load_products.dart';
import 'package:meqamax/pages/ecommerce/filter.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/widgets/icon_button.dart';

class PopularProductsPage extends StatefulWidget {
  const PopularProductsPage({super.key});

  @override
  State<PopularProductsPage> createState() => _PopularProductsPageState();
}

class _PopularProductsPageState extends State<PopularProductsPage> {
  Map filter = {};
  Map filterNames = {};
  List price = [0, Ecommerce.maxPrice];
  String disable = '';

  GlobalKey loadProductsKey = GlobalKey();

  void goToFilterPage(BuildContext context) async {
    final result = await Get.to(() => FilterPage(data: [filter, filterNames, price], disable: disable));

    // Handle the returned parameter here
    if (result != null) {
      setState(() {
        filter = result[0];
        filterNames = result[1];
        price = result[2];
      });
      loadProductsKey = GlobalKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return [
                SliverAppBar(
                  title: Text('Populyar məhsullar'.tr),
                  expandedHeight: 60.0,
                  toolbarHeight: 60.0,
                  leading: (Navigator.canPop(context)) ? MsIconButton(onTap: () => Navigator.of(context).pop()) : SizedBox(),
                ),
              ];
            },
            body: LoadProducts(
              key: loadProductsKey,
              tools: true,
              type: 'popular',
              filter: filter,
              goToFilterPage: () => goToFilterPage(context),
            )),
      ),
    );
  }
}
