import 'dart:convert';

import 'package:get/get.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:http/http.dart' as http;

class NotificationController {
  RxList notifications = [].obs;
  RxInt unread = 0.obs;
  final loginController = Get.put(LoginController());

  get() async {
    if (await checkConnectivity()) {
      var query = '${App.domain}/api/notify.php?action=get&lang=${Get.locale?.languageCode}&session_key=${loginController.userId.value}';
      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (result['status'] == 'success') {
          notifications.value = result['result'];
          count();
        }
      }
    }
  }

  seen() async {
    if (await checkConnectivity()) {
      var query = '${App.domain}/api/notify.php?action=seen&lang=${Get.locale?.languageCode}&session_key=${loginController.userId.value}';
      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (result['status'] == 'success') {
          notifications.value = result['result'];
          count();
        }
      }
    }
  }

  count() {
    unread.value = 0;
    for (var item in notifications) {
      if (item['notify_status'] == '0') {
        unread.value++;
      }
    }
  }
}
