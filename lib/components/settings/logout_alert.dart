import 'package:meqamax/controllers/cart_controller.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/controllers/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutAlert extends StatelessWidget {
  LogoutAlert({super.key});

  final loginController = Get.put(LoginController());
  final cartController = Get.put(CartController());
  final wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(30.0),
      actionsPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      content: Text("Hesabınızdan çıxış etmək istədiyinizə əminsinizmi?".tr),
      actions: [
        TextButton(
          child: Text("Xeyr".tr),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: Text("Bəli".tr),
          onPressed: () {
            loginController.logout();
            cartController.get();
            wishlistController.get();
            Get.back();
          },
        ),
      ],
    );
  }
}
