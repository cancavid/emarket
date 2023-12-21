import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/themes/theme.dart';

class SocialLogin {
  Future socialLogin(socialId, socialPlatform, info) async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/auth.php?action=social"));

      request.fields['social_id'] = socialId;
      request.fields['social_platform'] = socialPlatform;
      request.fields['info'] = json.encode(info);

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));
        if (result['status'] == 'success') {
          if (result['result']['user_status'] == 1) {
            final loginController = Get.put(LoginController());
            loginController.update(true, result['result'], socialPlatform);
            Get.back();
          } else {
            Get.snackbar('Xəta', 'Sizin hesabınız aktiv deyil.');
          }
        }
      }
    }
  }
}
