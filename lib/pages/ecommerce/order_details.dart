import 'package:meqamax/controllers/cart_controller.dart';
import 'package:meqamax/pages/ecommerce/single_order.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/navigator.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    cartController.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryBg,
      appBar: MsAppBar(title: 'Sifariş qeydə alındı'.tr),
      body: MsNotify(
        heading: 'Sifarişiniz uğurla qeydə alındı'.tr,
        type: MsNotifyTypes.success,
        action: () {
          navigatePage(context, SingleOrderPage(orderId: widget.orderId));
        },
        actionText: 'Sifarişə bax'.tr,
      ),
    );
  }
}
