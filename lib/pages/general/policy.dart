import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/html.dart';
import 'package:meqamax/widgets/refresh_indicator.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({super.key});

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  String content = '';

  get() async {
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/page.php?action=get&id=10&lang=${Get.locale?.languageCode}');
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
    get();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
    });
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Məxfilik siyasəti'.tr),
      body: MsRefreshIndicator(
        onRefresh: () {
          _refreshPage();
          return Future.value();
        },
        child: MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: _refreshPage,
          child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                padding: const EdgeInsets.all(25.0),
                children: [
                  MsHtml(data: content),
                ],
              )),
        ),
      ),
    );
  }
}
