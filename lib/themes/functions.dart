import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

int getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}

String removeHtmlTags(String htmlString) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlString.replaceAll(exp, '');
}

Color hexToColor(String colorCode) {
  String colorString = colorCode.replaceAll('#', '0xFF');
  return Color(int.parse(colorString));
}

redirectUrl(context, url) async {
  url = url.replaceAll(RegExp(r'/$'), '');
  List<String> pathSegments = Uri.parse(url).pathSegments;
  if (pathSegments.isNotEmpty) {
    if (RegExp(r'^[a-zA-Z]{2}$').hasMatch(pathSegments[0])) {
      pathSegments.removeAt(0);
      pathSegments = pathSegments.asMap().values.toList();
    }
    if (pathSegments[0] == 'brand') {
      var brand = pathSegments[1];
      Navigator.of(context).pushNamed('/brand/', arguments: [brand]);
    } else if (pathSegments[0] == 'mehsul-kateqoriyasi') {
      var category = pathSegments[1];
      Navigator.of(context).pushNamed('/mehsul-kateqoriyasi/', arguments: [category]);
    } else if (pathSegments[0] == 'mehsul' && pathSegments.length > 1) {
      var product = pathSegments[1];
      Navigator.of(context).pushNamed('/mehsul/', arguments: [product]);
    } else {
      var slug = pathSegments[0];
      if (await checkConnectivity()) {
        var request = Uri.parse('${App.domain}/api/posts.php?action=get&slug=$slug&lang=${Get.locale?.languageCode}');
        var response = await http.get(request);
        if (response.statusCode == 200) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            if (result['result']['post_type'] == 'post') {
              Navigator.of(context, rootNavigator: true).pushNamed('/post/', arguments: [slug]);
            } else {
              launchUrl(Uri.parse(url));
            }
          } else {
            launchUrl(Uri.parse(url));
          }
        }
      }
    }
  }
}

getDataFromSlug(slug, {type = 'post'}) async {
  if (await checkConnectivity()) {
    var url = Uri.parse('${App.domain}/api/slug.php?action=get&slug=$slug&type=$type');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success') {
        return result['result'];
      }
    }
  }
}
