import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/products/load_products.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/controllers/tabbar_controller.dart';
import 'package:meqamax/controllers/wishlist_controller.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:meqamax/widgets/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool loading = false;
  bool serverError = false;
  bool connectError = false;
  String error = '';

  final loginController = Get.put(LoginController());
  final wishlistController = Get.put(WishlistController());
  final tabBarController = Get.put(TabBarController());
  final box = GetStorage();
  GlobalKey loadProductsKey = GlobalKey();

  get() async {
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/wishlist.php?action=list&session_key=${loginController.userId.value}&lang=${Get.locale?.languageCode}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              wishlistController.update(result['result']);
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

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
    });
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'İstək listi'.tr),
      body: Obx(() {
        loadProductsKey = GlobalKey();
        return MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: _refreshPage,
          child: (wishlistController.wishlist.isEmpty)
              ? MsNotify(heading: 'İstək listiniz boşdur'.tr, action: _refreshPage)
              : MsRefreshIndicator(
                  onRefresh: () {
                    _refreshPage();
                    return Future.value();
                  },
                  child: LoadProducts(
                    key: (tabBarController.index.value != 2) ? loadProductsKey : Key(''),
                    multiple: wishlistController.wishlist.reversed.join(','),
                  ),
                ),
        );
      }),
    );
  }
}
