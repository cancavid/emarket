import 'dart:convert';

import 'package:meqamax/themes/theme.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/controllers/login_controller.dart';

class CartController {
  RxMap data = {}.obs;
  RxList cart = [].obs;
  RxInt quantity = 0.obs;
  final loginController = Get.put(LoginController());

  Future<void> get() async {
    var url = Uri.parse('${App.domain}/api/cart.php?action=get&session_key=${loginController.userId}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success') {
        data.value = result['result'];
        cart.value = result['result']['cart'];
      } else {
        data.value = {};
        cart.value = [];
      }
      count();
    }
  }

  void update(value) {
    data.value = value;
    cart.value = data['cart'];
    count();
  }

  void count() {
    int count = 0;
    for (int i = 0; i < cart.length; i++) {
      count = count + int.parse(cart[i]['cart_quantity'].toString());
    }
    quantity.value = count;
  }
}
