import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentDeclinedPage extends StatelessWidget {
  const PaymentDeclinedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Ödəmə problemi'.tr),
      body: MsNotify(
        heading: 'Ödəniş zamanı xəta baş verdi.'.tr,
        action: () {
          Get.back();
        },
        actionText: 'Geriyə qayıt'.tr,
      ),
    );
  }
}
