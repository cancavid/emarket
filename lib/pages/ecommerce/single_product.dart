import 'dart:convert';

import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/single_product/appbar.dart';
import 'package:meqamax/components/single_product/bottom.dart';
import 'package:meqamax/components/single_product/combine_related_products.dart';
import 'package:meqamax/components/single_product/components.dart';
import 'package:meqamax/components/single_product/title.dart';
import 'package:meqamax/components/single_product/variation.dart';
import 'package:meqamax/controllers/cart_controller.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/controllers/wishlist_controller.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/refresh_indicator.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SingleProductPage extends StatefulWidget {
  final Map? data;
  final String? id;
  final String? slug;
  const SingleProductPage({super.key, this.data, this.id, this.slug});

  @override
  State<SingleProductPage> createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  Map data = {};
  List combine = [];
  List related = [];
  String productId = '';
  String variationId = '';
  int quantity = 1;
  bool loading = false;
  bool serverError = false;
  bool connectError = false;
  bool buttonLoading = false;
  bool wishlistLoading = false;
  bool attention = false;
  String error = '';
  List slide = [];
  final loginController = Get.put(LoginController());
  final cartController = Get.put(CartController());
  final wishlistController = Get.put(WishlistController());

  final ScrollController _scrollController = ScrollController();
  GlobalKey containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      data = widget.data!;
      productId = data['post_id'];
    } else {
      loading = true;
      get();
    }
  }

  void setVariation(String id) {
    setState(() {
      variationId = id;
    });
  }

  void updateQuantity(action) {
    if (action == 'increase') {
      setState(() {
        quantity++;
      });
    } else {
      if (quantity > 1) {
        setState(() {
          quantity--;
        });
      }
    }
  }

  get() async {
    if (await checkConnectivity()) {
      String query = '${App.domain}/api/product.php?action=get&lang=${Get.locale?.languageCode}';
      if (widget.slug != null) {
        query = '$query&slug=${widget.slug}';
      } else {
        query = '$query&id=$productId';
      }
      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              data = result['result']['postdata'];
              combine = result['result']['combine'];
              related = result['result']['related'];
            });
          } else {
            setState(() {
              loading = false;
              error = result['error'];
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

  addToCart() async {
    setState(() {
      buttonLoading = true;
      attention = false;
    });
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/cart.php?action=update&process=increase&product_id=$productId&variation_id=$variationId&quantity=$quantity&session_key=${loginController.userId.value}&lang=${Get.locale?.languageCode}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              buttonLoading = false;
              cartController.update(result['result']);
              showSnackBar(context, 'Məhsul uğurla səbətə əlavə edildi.'.tr, type: SnackBarTypes.success);
            });
          } else {
            setState(() {
              buttonLoading = false;
              showSnackBar(context, result['error']);
              scrollToAttributes();
            });
          }
        }
      } else {
        setState(() {
          buttonLoading = false;
          showSnackBar(context, 'Serverlə əlaqə yaratmaq mümkün olmadı.'.tr);
        });
      }
    } else {
      setState(() {
        buttonLoading = false;
        showSnackBar(context, 'İnternet bağlantısı probleminiz var.'.tr);
      });
    }
  }

  addWishlist(productId) async {
    setState(() {
      wishlistLoading = true;
    });
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/wishlist.php?action=update&product_id=$productId&session_key=${loginController.userId.value}&lang=${Get.locale?.languageCode}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              wishlistLoading = false;
              wishlistController.update(result['result']['list']);
            });
          } else {
            setState(() {
              wishlistLoading = false;
              showSnackBar(context, result['error']);
            });
          }
        }
      }
    }
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
    });
    get();
  }

  void _changeGallery(data) {
    setState(() {
      slide = data;
    });
  }

  void scrollToAttributes() {
    setState(() {
      attention = true;
    });
    _scrollController.animateTo(
      containerKey.currentContext!.findRenderObject()!.semanticBounds.top + 300,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: (data.isNotEmpty)
            ? SingleProductBottom(
                stock: data['stock'].toString(),
                quantity: quantity,
                quantityAction: updateQuantity,
                addToCartAction: addToCart,
                buttonLoading: buttonLoading,
              )
            : SizedBox(),
        body: MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: _refreshPage,
          child: (error != '')
              ? MsNotify(heading: error)
              : MsRefreshIndicator(
                  onRefresh: () {
                    _refreshPage();
                    return Future.value();
                  },
                  child: CustomScrollView(controller: _scrollController, slivers: [
                    SingleProductAppBar(
                      wishlistLoading: wishlistLoading,
                      onTap: () => addWishlist(data['post_id']),
                      data: data,
                      slide: slide,
                    ),
                    SliverToBoxAdapter(
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            SingleProductTitle(data: data),
                            if (data['product_type'] == 'variable') ...[
                              Divider(height: 5.0, thickness: 5.0, color: Theme.of(context).colorScheme.bg),
                              VariationProduct(
                                id: data['post_id'],
                                action: setVariation,
                                gallery: data['variation_gallery'],
                                slideAction: _changeGallery,
                                containerKey: containerKey,
                                attention: attention,
                              ),
                            ],
                            SingleProductComponents(data: data),
                            CombinedProducts(multiple: data['combine'], data: combine)
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
        ));
  }
}
