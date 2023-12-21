import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/themes/functions.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/html.dart';

checkVersion() async {
  int version = 0;
  int currentVersion = 0;
  String changelog = '';

  if (await checkConnectivity()) {
    var url = Uri.parse('${App.domain}/api/page.php?id=21');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success') {
        version = getExtendedVersionNumber(result['result']['version']);
        changelog = result['result']['changelog'];
      }
    }
  }

  final info = await PackageInfo.fromPlatform();
  currentVersion = getExtendedVersionNumber(info.version);

  // ignore: unrelated_type_equality_checks
  if (version != 0 && version == currentVersion) {
    Get.defaultDialog(
      radius: 10.0,
      contentPadding: const EdgeInsets.fromLTRB(30.0, 0, 25.0, 0.0),
      titlePadding: const EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 15.0),
      title: 'Tətbiqin yeni versiyası mövcuddur:',
      middleText: '',
      middleTextStyle: TextStyle(fontSize: 0),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MsHtml(data: changelog),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('İmtina et')),
              TextButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse('https://masterstudio.az'));
                  },
                  child: Text('Yenilə'))
            ],
          ),
        ],
      ),
    );
  }
}
