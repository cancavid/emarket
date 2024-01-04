import 'package:get_storage/get_storage.dart';
import 'package:meqamax/components/products/load_products.dart';
import 'package:meqamax/pages/ecommerce/filter.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/themes/functions.dart';
import 'package:meqamax/widgets/icon_button.dart';

class SingleTaxonomyPage extends StatefulWidget {
  final String? categoryId;
  final String? brandId;
  final String? title;
  final String? slug;
  const SingleTaxonomyPage({super.key, this.categoryId, this.brandId, this.title, this.slug});

  @override
  State<SingleTaxonomyPage> createState() => _SingleTaxonomyPageState();
}

class _SingleTaxonomyPageState extends State<SingleTaxonomyPage> {
  String title = '';
  String brandId = '';
  String categoryId = '';
  Map filter = {};
  Map filterNames = {};
  List price = [0, Ecommerce.maxPrice];
  bool update = false;
  String disable = '';
  final box = GetStorage();
  GlobalKey loadProductsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      title = widget.title!;
    }
    if (widget.categoryId != null) {
      filter = {
        'mehsul-kateqoriyasi': {(widget.categoryId)}
      };
      disable = 'mehsul-kateqoriyasi';
    } else if (widget.brandId != null) {
      filter = {
        'brand': {(widget.brandId)}
      };
      disable = 'brand';
    }
    if (widget.slug != null) {
      getDataFromSlug(widget.slug, type: 'term').then((data) {
        if (data != null) {
          setState(() {
            title = data['term_name'];
            if (data['term_taxonomy'] == 'mehsul-kateqoriyasi') {
              categoryId = data['term_id'];
              filter = {
                'mehsul-kateqoriyasi': {(categoryId)}
              };
              disable = 'mehsul-kateqoriyasi';
            } else if (data['term_taxonomy'] == 'brand') {
              brandId = data['term_id'];
              filter = {
                'brand': {(brandId)}
              };
              disable = 'brand';
            }
          });
        }
      });
    }
  }

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
                  title: Text(title),
                  expandedHeight: 60.0,
                  toolbarHeight: 60.0,
                  leading: (Navigator.canPop(context))
                      ? MsIconButton(
                          margin: const EdgeInsets.only(left: 10.0),
                          onTap: () => Navigator.of(context).pop(),
                        )
                      : SizedBox(),
                ),
              ];
            },
            body: (filter.isNotEmpty)
                ? LoadProducts(
                    key: loadProductsKey,
                    tools: true,
                    filter: filter,
                    goToFilterPage: () => goToFilterPage(context),
                  )
                : SizedBox()),
      ),
    );
  }
}
