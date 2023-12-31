import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/posts/campaign_products.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/html.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:meqamax/widgets/refresh_indicator.dart';
import 'package:meqamax/widgets/image.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class SingleCampaign extends StatefulWidget {
  final Map? data;
  final String? id;
  final String? slug;
  const SingleCampaign({super.key, this.data, this.id, this.slug});

  @override
  State<SingleCampaign> createState() => _SingleCampaignState();
}

class _SingleCampaignState extends State<SingleCampaign> {
  bool loading = false;
  bool serverError = false;
  bool connectError = false;
  bool noPosts = false;
  Map data = {};
  String id = '';

  get() async {
    if (await checkConnectivity()) {
      String query = '${App.domain}/api/posts.php?action=get&lang=${Get.locale?.languageCode}';
      if (widget.slug != null) {
        query = '$query&slug=${widget.slug}';
      } else {
        query = '$query&id=$id';
      }
      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (mounted) {
          setState(() {
            loading = false;
            if (result['status'] == 'success') {
              data = result['result'];
            } else {
              noPosts = true;
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

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
    });
    get();
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      data = widget.data!;
      id = data['post_id'].toString();
    } else {
      loading = true;
      get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (data.isNotEmpty)
          ? FloatingActionButton(
              onPressed: () {
                Share.share(data['url']);
              },
              child: Icon(Icons.share))
          : SizedBox(),
      body: MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        action: _refreshPage,
        child: (data.isEmpty)
            ? (noPosts)
                ? MsNotify(
                    heading: 'Bu barədə heç bir məlumat tapılmadı.'.tr,
                    action: _refreshPage,
                  )
                : MsIndicator()
            : MsRefreshIndicator(
                onRefresh: () {
                  _refreshPage();
                  return Future.value();
                },
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverAppBar(
                      iconTheme: const IconThemeData(color: Colors.white),
                      expandedHeight: 350.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            MsImage(
                              url: data['media_url'],
                              width: MediaQuery.of(context).size.width,
                              height: 350.0 + MediaQuery.of(context).padding.top,
                              pSize: (MediaQuery.of(context).size.width - 40) / 4,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: Theme.of(context).colorScheme.gradient,
                              ),
                            ),
                            Positioned(
                              width: MediaQuery.of(context).size.width,
                              bottom: 0,
                              left: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(
                                    data['post_title'],
                                    style: GoogleFonts.dmSans(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 7.0),
                                  Text(
                                    data['post_date'],
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.grey2,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: MsContainer(
                        loading: loading,
                        serverError: serverError,
                        connectError: connectError,
                        action: _refreshPage,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: MsHtml(data: data['post_content']),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CampaignProducts(multiple: data['combine']),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
