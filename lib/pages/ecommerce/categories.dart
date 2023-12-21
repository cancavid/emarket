import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:meqamax/pages/ecommerce/single_taxonomy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/image.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class CategoriesPage extends StatefulWidget {
  final List? terms;
  final String? title;
  final String parentId;
  const CategoriesPage({super.key, this.terms, this.title, this.parentId = '0'});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List<dynamic> terms = [];

  Future<void> get() async {
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/terms.php?action=get&taxonomy=mehsul-kateqoriyasi&parent_id=${widget.parentId}&show_parent=1&lang=${Get.locale?.languageCode}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          setState(() {
            loading = false;
            if (result['status'] == 'success') {
              terms = result['result'];
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
    if (widget.terms == null) {
      get();
    } else {
      terms = widget.terms!;
      loading = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshPage() {
    setState(() {
      terms = [];
      loading = true;
      serverError = false;
      connectError = false;
    });
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MsAppBar(title: (widget.title != null) ? widget.title! : 'Kateqoriyalar'.tr),
        body: MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: _refreshPage,
          child: (terms.isEmpty)
              ? MsNotify(
                  heading: 'Heç bir kateqoriya tapılmadı'.tr,
                  type: MsNotifyTypes.info,
                )
              : Ink(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryBg,
                    border: Border(top: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.grey4)),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: terms.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (terms[index].containsKey('children')) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoriesPage(
                                          terms: terms[index]['children'],
                                          title: terms[index]['term_name'],
                                          parentId: terms[index]['term_id'],
                                        )));
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SingleTaxonomyPage(title: terms[index]['term_name'], categoryId: terms[index]['term_id'])),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Theme.of(context).colorScheme.bg),
                                      child: Center(
                                        child: MsImage(
                                          url: terms[index]['term_thumbnail'],
                                          height: 25.0,
                                          width: 25.0,
                                          color: Theme.of(context).colorScheme.grey1,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15.0),
                                    Expanded(child: Text(terms[index]['term_name'])),
                                  ],
                                ),
                              ),
                              MsSvgIcon(
                                icon: 'assets/interface/right.svg',
                                size: 12.0,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 1.0, thickness: 1.0, color: Theme.of(context).colorScheme.grey4);
                    },
                  ),
                ),
        ));
  }
}
