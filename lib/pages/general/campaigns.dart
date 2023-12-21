import 'dart:convert';

import 'package:get/get.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/posts/single_post_item.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:http/http.dart' as http;

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({super.key});

  @override
  State<CampaignsPage> createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List<dynamic> posts = [];
  bool noPosts = false;
  int limit = 10;
  int offset = 0;

  Future<void> get(bool scroll) async {
    if (await checkConnectivity()) {
      var query = '${App.domain}/api/posts.php?action=get&post_type=post&limit=$limit&offset=$offset&lang=${Get.locale?.languageCode}';
      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              if (scroll) {
                posts = posts + result['result'];
              } else {
                posts = result['result'];
              }
            });
          } else {
            setState(() {
              loading = false;
              noPosts = true;
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
    get(false);
  }

  void _refreshPage() {
    setState(() {
      posts = [];
      loading = true;
      serverError = false;
      connectError = false;
      noPosts = false;
      offset = 0;
    });
    get(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Kampaniyalar'.tr),
      body: MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: _refreshPage,
          child: RefreshIndicator(
            onRefresh: () {
              _refreshPage();
              return Future.value();
            },
            child: (posts.isNotEmpty)
                ? ListView.separated(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: posts.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == posts.length) {
                        if (noPosts) {
                          return Text(
                            'Göstəriləcək başqa xəbər yoxdur.'.tr,
                            textAlign: TextAlign.center,
                          );
                        } else if (posts.length < limit) {
                          return SizedBox();
                        } else {
                          return VisibilityDetector(
                              key: UniqueKey(),
                              onVisibilityChanged: (visibilityInfo) {
                                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                                if (visiblePercentage == 100) {
                                  setState(() {
                                    offset = offset + limit;
                                    get(true);
                                  });
                                }
                              },
                              child: MsIndicator());
                        }
                      } else {
                        return SingleCampaignItem(data: posts[index]);
                      }
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 20.0);
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Heç bir kampaniya tapılmadı.'.tr, textAlign: TextAlign.center),
                  ),
          )),
    );
  }
}
