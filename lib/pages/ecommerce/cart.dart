import 'dart:convert';

import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/cart/cart_bottom_navigation.dart';
import 'package:meqamax/components/cart/cart_item.dart';
import 'package:meqamax/components/cart/cart_total.dart';
import 'package:meqamax/controllers/cart_controller.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:meqamax/widgets/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool loading = false;
  bool serverError = false;
  bool connectError = false;
  bool mainLoading = false;

  int quantity = 0;
  String cartError = '';
  String error = '';
  List cart = [];

  final loginController = Get.put(LoginController());
  final cartController = Get.put(CartController());

  fetchData(query) async {
    if (await checkConnectivity()) {
      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              mainLoading = false;
              cartController.update(result['result']);
            });
          } else {
            setState(() {
              loading = false;
              mainLoading = false;
              error = result['error'];
              cartController.update(result['result']);
            });
          }
        }
      } else {
        setState(() {
          loading = false;
          mainLoading = false;
          serverError = true;
        });
      }
    } else {
      setState(() {
        loading = false;
        mainLoading = false;
        connectError = true;
      });
    }
  }

  Future<void> get() async {
    setState(() {
      loading = true;
    });
    fetchData('${App.domain}/api/cart.php?action=get&session_key=${loginController.userId.value}&lang=${Get.locale?.languageCode}');
  }

  Future<void> _decrease(productId, variationId, date) async {
    setState(() {
      mainLoading = true;
    });
    fetchData('${App.domain}/api/cart.php?action=update&process=decrease&product_id=$productId&variation_id=$variationId&date=$date&session_key=${loginController.userId.value}&lang=${Get.locale?.languageCode}');
  }

  Future<void> _increase(productId, variationId, date) async {
    setState(() {
      mainLoading = true;
    });
    fetchData('${App.domain}/api/cart.php?action=update&process=increase&product_id=$productId&variation_id=$variationId&date=$date&session_key=${loginController.userId.value}&lang=${Get.locale?.languageCode}');
  }

  Future<void> _remove(productId, variationId) async {
    setState(() {
      mainLoading = true;
    });
    fetchData('${App.domain}/api/cart.php?action=remove&product_id=$productId&variation_id=$variationId&session_key=${loginController.userId.value}&lang=${Get.locale?.languageCode}');
  }

  @override
  void initState() {
    super.initState();
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
      cart = [];
      error = '';
    });
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Səbət'.tr),
      bottomNavigationBar: Obx(() => (cartController.cart.isNotEmpty) ? CartBottomNavigation(data: cartController.data) : SizedBox()),
      body: Obx(
        () => MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: _refreshPage,
          child: (loading)
              ? MsIndicator()
              : (error != '')
                  ? MsNotify(heading: error, image: 'assets/images/empty_cart.png', action: _refreshPage)
                  : (cartController.cart.isEmpty)
                      ? MsNotify(heading: 'Səbətiniz boşdur'.tr, image: 'assets/images/empty_cart.png', action: _refreshPage)
                      : Stack(
                          children: [
                            MsRefreshIndicator(
                              onRefresh: () {
                                _refreshPage();
                                return Future.value();
                              },
                              child: ListView.separated(
                                  itemCount: cartController.cart.length + 1,
                                  itemBuilder: (context, index) {
                                    bool variation = false;

                                    if (index != cartController.cart.length && cartController.cart[index]['cart_variation_id'] != 0) {
                                      variation = true;
                                    }

                                    return (index == cartController.cart.length)
                                        ? CartTotal(cart: cartController.data)
                                        : CartItem(
                                            data: cartController.cart[index],
                                            increase: _increase,
                                            decrease: _decrease,
                                            remove: _remove,
                                            variation: variation,
                                          );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      height: 1.0,
                                      thickness: 1.0,
                                      color: Theme.of(context).colorScheme.grey4,
                                    );
                                  }),
                            ),
                            if (mainLoading) ...[
                              Positioned.fill(
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Theme.of(context).colorScheme.secondaryBg.withOpacity(.85),
                                  child: Center(
                                    child: MsIndicator(),
                                  ),
                                ),
                              )
                            ]
                          ],
                        ),
        ),
      ),
    );
  }
}
