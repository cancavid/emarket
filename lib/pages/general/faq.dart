import 'dart:convert';

import 'package:get/get.dart';
import 'package:meqamax/widgets/accordion.dart';
import 'package:meqamax/widgets/icon_button.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/html.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;

  List faq = [];
  int activeFaq = 0;
  int activeFaqItem = 0;

  get() async {
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/page.php?action=get&id=4&lang=${Get.locale?.languageCode}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (mounted) {
          setState(() {
            loading = false;
            if (result['status'] == 'success') {
              faq = result['result']['faq'];
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
    return DefaultTabController(
      length: faq.length,
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondaryBg,
          appBar: AppBar(
            leading: MsIconButton(onTap: () => Navigator.of(context).pop()),
            title: Text('Ən çox soruşulan suallar'.tr),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                for (var index = 0; index < faq.length; index++) ...[
                  Tab(
                    text: faq[index]['f_main_heading'],
                  )
                ]
              ],
            ),
          ),
          body: Container(
            color: Theme.of(context).colorScheme.bg,
            child: MsContainer(
              loading: loading,
              serverError: serverError,
              connectError: connectError,
              action: _refreshPage,
              child: TabBarView(
                children: [
                  for (var index = 0; index < faq.length; index++)
                    ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView(padding: const EdgeInsets.all(25.0), shrinkWrap: true, children: [
                        for (var i = 0; i < faq[index]['f_questions'].length; i++)
                          MsAccordion(
                            onTap: () {
                              setState(() {
                                if (activeFaqItem == i) {
                                  activeFaqItem = -1;
                                } else {
                                  activeFaqItem = i;
                                }
                              });
                            },
                            title: Text(
                              faq[index]['f_questions'][i]['f_question'],
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                height: 1.4,
                                color: (activeFaqItem == i) ? Theme.of(context).colorScheme.secondaryColor : Theme.of(context).colorScheme.grey1,
                                fontWeight: (activeFaqItem == i) ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                            content: MsHtml(data: faq[index]['f_questions'][i]['f_answer']),
                            active: (activeFaqItem == i) ? true : false,
                          ),
                      ]),
                    )
                ],
              ),
            ),
          )),
    );
  }
}
