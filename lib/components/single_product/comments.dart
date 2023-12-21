import 'dart:convert';

import 'package:get/get.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/pages/ecommerce/add_comment.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/behaviour.dart';
import 'package:meqamax/widgets/bottom_sheet.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/rating.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductComments extends StatefulWidget {
  final String id;
  const ProductComments({super.key, required this.id});

  @override
  State<ProductComments> createState() => _ProductCommentsState();
}

class _ProductCommentsState extends State<ProductComments> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List comments = [];
  String error = 'Hazırda heç bir rəy bildirilməmişdir.'.tr;

  get() async {
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/comments.php?action=get&post_id=${widget.id}&lang=${Get.locale?.languageCode}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              comments = result['result']['comments'];
            });
          } else {
            setState(() {
              loading = false;
              error = result['error'];
            });
          }
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
  Widget build(BuildContext context) {
    return MsBottomSheet(
      child: Expanded(
        child: MsContainer(
            loading: loading,
            serverError: serverError,
            connectError: connectError,
            action: null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (comments.isEmpty)
                    ? Expanded(
                        child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Şərhlər'.tr, style: Theme.of(context).textTheme.extraLargeHeading),
                            SizedBox(height: 10.0),
                            Text(error),
                          ],
                        ),
                      ))
                    : Expanded(
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.separated(
                            padding: const EdgeInsets.all(20.0),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text(comments[index]['comment_author'])),
                                      SizedBox(width: 15.0),
                                      Text(
                                        comments[index]['comment_date'],
                                        style: TextStyle(fontSize: 11.0, color: Theme.of(context).colorScheme.grey2),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  MsRating(value: double.parse(comments[index]['comment_rating'])),
                                  SizedBox(height: 15.0),
                                  Container(
                                      padding: const EdgeInsets.all(15.0),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.bg,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Text(comments[index]['comment_content'])),
                                ],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return SizedBox(height: 20.0);
                            },
                          ),
                        ),
                      ),
                Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  color: Theme.of(context).colorScheme.secondaryBg,
                  child: MsButton(
                      onTap: () {
                        Get.to(() => AddCommentPage(id: widget.id));
                      },
                      icon: true,
                      title: 'Şərh bildir'.tr),
                )
              ],
            )),
      ),
    );
  }
}
