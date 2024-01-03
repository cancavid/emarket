import 'dart:convert';

import 'package:meqamax/themes/theme.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/controllers/login_controller.dart';

class WishlistController {
  RxList wishlist = [].obs;
  RxInt quantity = 0.obs;
  final loginController = Get.put(LoginController());

  Future<void> get() async {
    var url = Uri.parse('${App.domain}/api/wishlist.php?action=list&session_key=${loginController.userId.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success') {
        update(result['result']);
      }
    }
  }

  void update(data) {
    if (data != null) {
      wishlist.value = data;
      count();
    }
  }

  void count() {
    quantity.value = wishlist.length;
  }
}
