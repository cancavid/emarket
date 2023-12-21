import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/svg_icon.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/behaviour.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/html.dart';
import 'package:meqamax/widgets/refresh_indicator.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  String content = '';

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Yüklənir...',
    packageName: 'Yüklənir...',
    version: 'Yüklənir...',
    buildNumber: 'Yüklənir...',
    buildSignature: 'Yüklənir...',
    installerStore: 'Yüklənir...',
  );

  get() async {
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/page.php?action=get&id=2&lang=${Get.locale?.languageCode}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (mounted) {
          setState(() {
            loading = false;
            if (result['status'] == 'success') {
              content = result['result']['page_content_az'];
            }
          });
        }
      } else {
        setState(() {
          loading = false;
          serverError = true;
        });
      }
    } else {
      setState(() {
        loading = false;
        connectError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    get();
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
      content = '';
    });
    get();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Haqqımızda'.tr),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: MsRefreshIndicator(
          onRefresh: () {
            _refreshPage();
            return Future.value();
          },
          child: ListView(
            padding: const EdgeInsets.all(25.0),
            children: [
              SizedBox(height: 30.0),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.center,
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: MsSvgIcon(
                    icon: 'assets/interface/logo.svg',
                    size: 38.0,
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              Text(
                _packageInfo.appName,
                style: Theme.of(context).textTheme.mediumHeading,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Versiya:'.tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.smallTitle,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    _packageInfo.version,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.smallTitle,
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              MsContainer(
                loading: loading,
                serverError: serverError,
                connectError: connectError,
                action: _refreshPage,
                child: MsHtml(data: content),
              )
            ],
          ),
        ),
      ),
    );
  }
}
