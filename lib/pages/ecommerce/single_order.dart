import 'dart:convert';

import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/orders/order_info.dart';
import 'package:meqamax/components/orders/order_progress.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/themes/functions.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/image.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:meqamax/widgets/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SingleOrderPage extends StatefulWidget {
  final Map? data;
  final String orderId;
  const SingleOrderPage({super.key, required this.orderId, this.data});

  @override
  State<SingleOrderPage> createState() => _SingleOrderPageState();
}

class _SingleOrderPageState extends State<SingleOrderPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List products = [];
  bool noOrder = false;
  bool noProducts = false;
  Map data = {};

  var loginController = Get.put(LoginController());

  Future get() async {
    if (await checkConnectivity()) {
      var query = '${App.domain}/api/orders.php?action=get&session_key=${loginController.userId}&order_id=${widget.orderId}';
      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              data = result['result'];
              getProducts();
            });
          } else {
            setState(() {
              loading = false;
              noOrder = true;
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

  Future<void> getProducts() async {
    if (await checkConnectivity()) {
      var query = '${App.domain}/api/orders.php?action=products&session_key=${loginController.userId}&order_id=${widget.orderId}&lang=${Get.locale?.languageCode}';
      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              products = result['result'];
            });
          } else {
            setState(() {
              loading = false;
              noProducts = true;
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
    if (widget.data == null) {
      get();
    } else {
      data = widget.data!;
      getProducts();
    }
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
      noOrder = false;
    });
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Sifariş detalları'.tr),
      body: MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: _refreshPage,
          child: (noOrder)
              ? MsNotify(heading: 'Heç bir sifariş tapılmadı'.tr)
              : (loading)
                  ? MsIndicator()
                  : MsRefreshIndicator(
                      onRefresh: () {
                        _refreshPage();
                        return Future.value();
                      },
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryBg),
                              child: Column(
                                children: [
                                  OrderInfoItem(label: 'Sifariş tarixi'.tr, value: data['order_date']),
                                  SizedBox(height: 12.0),
                                  OrderInfoItem(label: 'Sifariş nömrəsi'.tr, value: data['order_number'], copy: true),
                                  SizedBox(height: 12.0),
                                  OrderInfoItem(label: 'Ödəniş üsulu'.tr, value: data['order_method']),
                                  SizedBox(height: 12.0),
                                  OrderInfoItem(label: 'Toplam ödəniş'.tr, value: '${data['order_total_price']} ${data['order_currency']}'),
                                ],
                              ),
                            ),
                            Divider(height: 10.0, thickness: 10.0, color: Theme.of(context).colorScheme.bg),
                            Container(
                              color: Theme.of(context).colorScheme.secondaryBg,
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrderProgressBar(data: data),
                                  SizedBox(height: 30.0),
                                  Text('Sifariş etdikləriniz:'.tr, style: Theme.of(context).textTheme.extraSmallTitle),
                                  SizedBox(height: 20.0),
                                  ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10.0),
                                            child: MsImage(
                                              url: products[index]['order_product_thumbnail'],
                                              width: 70.0,
                                              height: 95.0,
                                              pColor: Theme.of(context).colorScheme.bg,
                                            ),
                                          ),
                                          SizedBox(width: 15.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(removeHtmlTags(products[index]['order_product_name']), style: Theme.of(context).textTheme.extraSmallHeading),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Text(products[index]['order_quantity'], style: Theme.of(context).textTheme.bodySmall),
                                                    SizedBox(width: 5.0),
                                                    Text('x', style: Theme.of(context).textTheme.bodySmall),
                                                    SizedBox(width: 5.0),
                                                    Text('${fixedPrice(products[index]['order_single_price'])} ${data['order_currency']}', style: Theme.of(context).textTheme.bodySmall),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) {
                                      return SizedBox(height: 15.0);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 10.0, thickness: 10.0, color: Theme.of(context).colorScheme.bg),
                            Container(
                              color: Theme.of(context).colorScheme.secondaryBg,
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Sifarişçi məlumatları:'.tr, style: Theme.of(context).textTheme.extraSmallTitle),
                                  SizedBox(height: 10.0),
                                  Text('${data['order_first_name']} ${data['order_last_name']}'),
                                  SizedBox(height: 3.0),
                                  Text(data['order_phone']),
                                  SizedBox(height: 3.0),
                                  if (data['order_email'] != '') ...[
                                    Text(data['order_email']),
                                  ],
                                  SizedBox(height: 3.0),
                                  Text(data['order_address']),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
    );
  }
}
