import 'package:meqamax/pages/ecommerce/order_details.dart';
import 'package:meqamax/pages/ecommerce/payment_canceled.dart';
import 'package:meqamax/pages/ecommerce/payment_declined.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.url});

  final String url;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController controller;
  bool showProgess = false;
  double progressPercent = 0;
  String url = '';

  void conditions() {
    if (url == 'https://fashion.betasayt.com/odenis-bas-tutmadi/') {
      Get.close(2);
      Get.to(() => PaymentDeclinedPage());
    } else if (url == 'https://fashion.betasayt.com/sifaris-detallari/') {
      Get.close(2);
      Get.to(() => OrderDetailsPage(orderId: '16'));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Ödəniş səhifəsindən çıxış edirsiniz. Çıxış etdiyinizdə ödənişdən imtina etmiş olacaqsınız.'.tr),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('İmtina et'.tr)),
                TextButton(
                    onPressed: () {
                      Get.close(3);
                      Get.to(() => PaymentCanceledPage(), transition: Transition.fade);
                    },
                    child: Text('Çıxış'.tr))
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              showProgess = true;
              progressPercent = progress / 100;
              if (progressPercent == 1.0) {
                showProgess = false;
              }
            });
          },
          onNavigationRequest: (navigation) {
            if (navigation.url != url) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            setState(() {
              this.url = url;
            });
            if (url.contains('/sifaris-detallari/')) {
              Uri uri = Uri.parse(url);
              String? id = uri.queryParameters['order'];
              Get.close(2);
              Get.to(() => OrderDetailsPage(orderId: id!));
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onlayn ödəniş'.tr),
        leading: IconButton(
            onPressed: () {
              conditions();
            },
            icon: Icon(Icons.close)),
      ),
      body: Column(
        children: [
          if (showProgess) ...[
            LinearProgressIndicator(
              value: progressPercent,
              color: Theme.of(context).colorScheme.primaryColor,
              backgroundColor: Colors.white,
            )
          ],
          Expanded(
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
