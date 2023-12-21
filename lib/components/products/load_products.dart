import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:meqamax/components/products/single_product_item.dart';
import 'package:meqamax/components/products/sort_button.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LoadProducts extends StatefulWidget {
  final String? search;
  final String? multiple;
  final Map? filter;
  final List? price;
  final bool? tools;
  final String orderType;
  final String? type;
  final VoidCallback? goToFilterPage;

  const LoadProducts({
    super.key,
    this.search,
    this.multiple,
    this.filter,
    this.price,
    this.tools = false,
    this.orderType = 'new',
    this.type,
    this.goToFilterPage,
  });

  @override
  State<LoadProducts> createState() => _LoadProductsState();
}

class _LoadProductsState extends State<LoadProducts> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List<dynamic> posts = [];
  bool noPosts = false;
  int limit = 10;
  int offset = 0;
  String orderType = '';

  Future<void> get(bool scroll) async {
    if (await checkConnectivity()) {
      var query = '${App.domain}/api/posts.php?action=get&post_type=mehsul&image_size=product&limit=$limit&offset=$offset&order=${Ecommerce.sorts[orderType]![1]}&orderby=${Ecommerce.sorts[orderType]![2]}&lang=${Get.locale?.languageCode}';

      if (widget.search != null) {
        query = '$query&search=${widget.search}';
      }

      if (widget.multiple != null) {
        query = '$query&multiple=${widget.multiple}';
      }

      if (widget.filter != null) {
        widget.filter!.forEach((key, value) {
          String values = value.join(',');
          query = '$query&$key=$values';
        });
      }

      if (widget.price != null) {
        query = '$query&min=${widget.price![0]}&max=${widget.price![1]}';
      }

      if (widget.type != null) {
        query = '$query&type=popular';
      }

      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              if (scroll) {
                posts = posts + result['result'];
              } else {
                posts = result['result'];
              }
            });
          } else {
            setState(() {
              loading = false;
              noPosts = true;
            });
          }
        }
      } else {
        setState(() {
          loading = false;
          serverError = true;
        });
      }
    } else {
      setState(() {
        loading = false;
        connectError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    orderType = widget.orderType;
    get(false);
  }

  void _refreshPage() {
    setState(() {
      posts = [];
      loading = true;
      serverError = false;
      connectError = false;
      noPosts = false;
      offset = 0;
    });
    get(false);
  }

  void sort(value) {
    setState(() {
      orderType = value;
      posts = [];
      loading = true;
      serverError = false;
      connectError = false;
      noPosts = false;
      offset = 0;
    });
    get(false);
  }

  @override
  Widget build(BuildContext context) {
    return MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        action: _refreshPage,
        child: RefreshIndicator(
          onRefresh: () {
            _refreshPage();
            return Future.value();
          },
          child: Column(
            children: [
              if (widget.tools != null && widget.tools == true) ...[
                Container(
                  color: Theme.of(context).colorScheme.secondaryBg,
                  child: Row(
                    children: [
                      SortButton(onChanged: sort, orderType: orderType),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.goToFilterPage,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.filter_alt_outlined),
                                    SizedBox(width: 10.0),
                                    Text('Filter'.tr),
                                  ],
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
              (posts.isNotEmpty)
                  ? Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(15.0),
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 3.5,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: posts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SingleProductItem(data: posts[index]);
                            },
                          ),
                          if (noPosts) ...[
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 20.0),
                              child: Text('Göstəriləcək başqa məhsul yoxdur.'.tr, textAlign: TextAlign.center),
                            ))
                          ] else if (posts.length < limit) ...[
                            SizedBox()
                          ] else ...[
                            VisibilityDetector(
                                key: Key(''),
                                onVisibilityChanged: (visibilityInfo) {
                                  var visiblePercentage = visibilityInfo.visibleFraction * 100;
                                  if (visiblePercentage == 100) {
                                    setState(() {
                                      offset = offset + limit;
                                      get(true);
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: MsIndicator(),
                                ))
                          ]
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Heç bir nəticə tapılmadı.'.tr, textAlign: TextAlign.center),
                    ),
            ],
          ),
        ));
  }
}
