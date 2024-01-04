import 'dart:convert';

import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/home/appbar.dart';
import 'package:meqamax/components/home/brands.dart';
import 'package:meqamax/components/home/carousel.dart';
import 'package:meqamax/components/home/stories.dart';
import 'package:meqamax/components/products/carousel_products.dart';
import 'package:meqamax/pages/ecommerce/new_products.dart';
import 'package:meqamax/pages/ecommerce/popular_products.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/widgets/indicator.dart';
import 'package:meqamax/widgets/refresh_indicator.dart';
import 'package:meqamax/widgets_extra/navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List newPosts = [];
  List trendPosts = [];
  List slides = [];
  List stories = [];
  List brands = [];
  bool noPosts = false;

  Future<void> get() async {
    if (await checkConnectivity()) {
      var query = '${App.domain}/api/home.php?action=get&lang=${Get.locale?.languageCode}';

      var url = Uri.parse(query);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              newPosts = result['result']['newPosts'];
              trendPosts = result['result']['trendPosts'];
              slides = result['result']['slides'];
              stories = result['result']['stories'];
              brands = result['result']['brands'];
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
    get();
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
      newPosts = [];
      trendPosts = [];
      slides = [];
      stories = [];
      brands = [];
      noPosts = false;
    });
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, scroll) {
          return [HomeAppBar()];
        },
        body: Container(
          color: Color.fromARGB(255, 23, 63, 172),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryBg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: MsRefreshIndicator(
                  onRefresh: () {
                    _refreshPage();
                    return Future.value();
                  },
                  child: (loading)
                      ? MsIndicator()
                      : ListView(children: [
                          Carousel(slides: slides),
                          Stories(stories: stories),
                          SizedBox(height: 30.0),
                          CarouselProducts(posts: newPosts, title: 'Yeni əlavə olunanlar'.tr, action: () => navigatePage(context, NewProductsPage())),
                          SizedBox(height: 30.0),
                          CarouselProducts(posts: trendPosts, title: 'Populyar məhsullar'.tr, action: () => navigatePage(context, PopularProductsPage())),
                          SizedBox(height: 30.0),
                          HomeBrands(brands: brands),
                        ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
