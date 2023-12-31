import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/products/carousel_products.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:http/http.dart' as http;

class CombinedProducts extends StatefulWidget {
  final String? multiple;
  final List? data;
  const CombinedProducts({super.key, this.multiple, this.data});

  @override
  State<CombinedProducts> createState() => _CombinedProductsState();
}

class _CombinedProductsState extends State<CombinedProducts> {
  bool loading = true;
  List posts = [];

  @override
  void initState() {
    super.initState();
    if (widget.data != null && widget.data!.isNotEmpty) {
      posts = widget.data!;
    } else if (widget.multiple != null) {
      get();
    } else {
      loading = false;
    }
  }

  get() async {
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/posts.php?action=get&post_type=mehsul&image_size=product&lang=${Get.locale?.languageCode}&multiple=${widget.multiple}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            setState(() {
              loading = false;
              posts = result['result'];
            });
          } else {
            setState(() {
              loading = false;
              posts = [];
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MsContainer(
      loading: loading,
      serverError: false,
      connectError: false,
      action: null,
      child: CarouselProducts(
        padding: EdgeInsets.symmetric(vertical: (posts.isEmpty) ? 0.0 : 15.0),
        title: 'Birgə ala biləcəkləriniz',
        posts: posts,
      ),
    );
  }
}
