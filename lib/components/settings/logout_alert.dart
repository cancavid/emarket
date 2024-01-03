import 'package:meqamax/controllers/cart_controller.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/controllers/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/widgets/dialog.dart';

class LogoutAlert extends StatelessWidget {
  LogoutAlert({super.key});

  final loginController = Get.put(LoginController());
  final cartController = Get.put(CartController());
  final wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return MsDialog(
      content: "Hesabınızdan çıxış etmək istədiyinizə əminsinizmi?".tr,
      actions: Row(
        children: [
          TextButton(
            child: Text("Xeyr".tr),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Bəli".tr),
            onPressed: () {
              loginController.logout();
              cartController.get();
              wishlistController.get();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
