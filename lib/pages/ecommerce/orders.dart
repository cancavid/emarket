import 'dart:convert';

import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/pages/ecommerce/single_order.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:meqamax/widgets/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:visibility_detector/visibility_detector.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List orders = [];
  String error = '';
  bool noOrders = false;
  int limit = 5;
  int offset = 0;

  var loginController = Get.put(LoginController());

  Map orderStatusColors = {
    'pending': Colors.orange,
    'completed': Colors.green,
    'cargo': Colors.pink,
    'confirmed': Colors.blue,
    'canceled': Colors.red,
  };

  Future<void> get(bool scroll) async {
    if (await checkConnectivity()) {
      var query = '${App.domain}/api/orders.php?action=get&session_key=${loginController.userId}&limit=$limit&offset=$offset&lang=${Get.locale?.languageCode}';
      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              if (scroll) {
                orders = orders + result['result'];
              } else {
                orders = result['result'];
              }
            });
          } else {
            setState(() {
              loading = false;
              error = result['error'];
              noOrders = true;
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
    get(false);
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
      offset = 0;
      error = '';
    });
    get(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Sifarişləriniz'.tr),
      body: MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        action: _refreshPage,
        child: (orders.isEmpty)
            ? (error != '')
                ? MsNotify(heading: error, action: _refreshPage)
                : MsIndicator()
            : MsRefreshIndicator(
                onRefresh: () {
                  _refreshPage();
                  return Future.value();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  itemCount: orders.length + 1,
                  itemBuilder: (context, index) {
                    return (index != orders.length)
                        ? InkWell(
                            onTap: () {
                              Get.to(() => SingleOrderPage(orderId: orders[index]['order_id'], data: orders[index]));
                            },
                            child: Stack(
                              children: [
                                Ink(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Theme.of(context).colorScheme.secondaryBg),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(orders[index]['order_date'], style: GoogleFonts.inter(fontSize: 13.0, fontWeight: FontWeight.w500)),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30.0),
                                              color: orderStatusColors[orders[index]['order_status']],
                                            ),
                                            child: Text(getOrderStatus(orders[index]['order_status']), style: GoogleFonts.inter(color: Colors.white, fontSize: 11.0, height: 1.15)),
                                          )
                                        ],
                                      ),
                                      Divider(
                                        height: 30.0,
                                        thickness: 1.0,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Sifariş:'.tr, style: Theme.of(context).textTheme.extraSmallTitle),
                                              SizedBox(width: 5.0),
                                              Text(orders[index]['order_number'], style: Theme.of(context).textTheme.extraSmallHeading),
                                            ],
                                          ),
                                          SizedBox(height: 5.0),
                                          Row(
                                            children: [
                                              Text('Toplam:'.tr, style: Theme.of(context).textTheme.extraSmallTitle),
                                              SizedBox(width: 5.0),
                                              Text('${orders[index]['order_total_price']} ${orders[index]['order_currency']}', style: Theme.of(context).textTheme.extraSmallHeading),
                                            ],
                                          ),
                                          SizedBox(height: 5.0),
                                          Row(
                                            children: [
                                              Text('Məhsul:'.tr, style: Theme.of(context).textTheme.extraSmallTitle),
                                              SizedBox(width: 5.0),
                                              Text(
                                                'order_products_count'.trParams({
                                                  'count': orders[index]['products'],
                                                }),
                                                style: Theme.of(context).textTheme.extraSmallHeading,
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    right: 15.0,
                                    bottom: 15.0,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Detallar'.tr,
                                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12.0, color: Theme.of(context).colorScheme.primaryColor, height: 1.25),
                                        ),
                                        SizedBox(width: 3.0),
                                        Icon(Icons.arrow_forward_ios_rounded, size: 12.0, color: Theme.of(context).colorScheme.primaryColor)
                                      ],
                                    ))
                              ],
                            ),
                          )
                        : (noOrders)
                            ? Text('Göstəriləcək başqa sifariş yoxdur.'.tr, textAlign: TextAlign.center)
                            : (orders.length < limit)
                                ? SizedBox()
                                : VisibilityDetector(
                                    key: Key(''),
                                    child: MsIndicator(),
                                    onVisibilityChanged: (visibilityInfo) {
                                      var visiblePercentage = visibilityInfo.visibleFraction * 100;
                                      if (visiblePercentage == 100) {
                                        setState(() {
                                          offset = offset + limit;
                                          get(true);
                                        });
                                      }
                                    },
                                  );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 15.0);
                  },
                ),
              ),
      ),
    );
  }
}
