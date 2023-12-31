import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/themes/theme.dart';

class LoginController {
  RxBool login = false.obs;
  RxString userId = ''.obs;
  RxString guestId = ''.obs;
  RxMap userdata = {}.obs;
  RxString token = ''.obs;
  final box = GetStorage();

  void get({tokenValue = ''}) {
    box.writeIfNull('login', false);
    box.writeIfNull('userId', '0');
    box.writeIfNull('guestId', '0');
    box.writeIfNull('platform', '');
    login.value = box.read('login');
    userId.value = box.read('userId');
    guestId.value = box.read('guestId');
    if (tokenValue != '') {
      setToken(tokenValue);
    }
    if (login.value) {
      getuserdata();
    } else {
      if (guestId.value != '0') {
        userId.value = guestId.value;
      } else {
        getToken();
      }
    }
  }

  void update(ulogin, udata, [platform = '']) {
    box.write('login', ulogin);
    box.write('platform', platform);
    login.value = ulogin;
    userdata.value = udata;
    if (userdata.isNotEmpty) {
      box.write('userId', udata['user_id'].toString());
      userId.value = udata['user_id'].toString();
      updateUserToken();
    }
  }

  Future<void> getuserdata() async {
    var url = Uri.parse('${App.domain}/api/users.php?action=get&session_key=${userId.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success' && result['result']['user_status'].toString() == '1') {
        userdata.value = result['result'];
        updateUserToken();
      } else {
        login.value = false;
        getToken();
      }
    }
  }

  Future<void> getToken() async {
    var url = Uri.parse('${App.domain}/api/auth.php?action=create');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success') {
        userId.value = result['result'];
        guestId.value = result['result'];
      } else {
        login.value = false;
      }
    }
  }

  void logout() async {
    deleteToken();
    login.value = false;
    userId.value = guestId.value;
    userdata.value = {};
    box.write('login', false);
    box.write('userId', guestId.value);
    box.write('userdata', {});
    String platform = box.read('platform');
    if (platform == 'Google') {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      googleSignIn.signOut();
    } else if (platform == 'Facebook') {
      // await FacebookAuth.instance.logOut();
    }
  }

  void setToken(value) {
    box.write('token', value);
    token.value = value;
  }

  void updateUserToken() async {
    if (login.value && userdata.isNotEmpty) {
      List tokens = json.decode(userdata['fcm_tokens'].replaceAll('&quot;', '"'));
      if (!tokens.contains(token.value)) {
        tokens.add(token.value);
        String data = json.encode(tokens);
        var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/users.php?action=update&session_key=${userId.value}"));
        request.fields['fcm_tokens'] = data;
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.toBytes();
          var result = json.decode(utf8.decode(responseData));
          if (result['status'] == 'success') {
            userdata.value = result['result']['user'];
          }
        }
      }
    }
  }

  void deleteToken() async {
    if (login.value && userdata.isNotEmpty) {
      List tokens = json.decode(userdata['fcm_tokens'].replaceAll('&quot;', '"'));
      if (tokens.contains(token.value)) {
        tokens.remove(token.value);
        String data = json.encode(tokens);
        var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/users.php?action=update&session_key=${userId.value}"));
        request.fields['fcm_tokens'] = data;
        await request.send();
      }
    }
  }
}
