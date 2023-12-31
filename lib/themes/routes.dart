import 'package:flutter/material.dart';
import 'package:meqamax/pages/ecommerce/single_product.dart';
import 'package:meqamax/pages/ecommerce/single_taxonomy.dart';
import 'package:meqamax/pages/general/single_campaign.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/brand/': (context) {
      final arguments = ModalRoute.of(context)!.settings.arguments as List?;
      return SingleTaxonomyPage(slug: arguments?.isNotEmpty == true ? arguments![0] as String : null);
    },
    '/mehsul-kateqoriyasi/': (context) {
      final arguments = ModalRoute.of(context)!.settings.arguments as List?;
      return SingleTaxonomyPage(slug: arguments?.isNotEmpty == true ? arguments![0] as String : null);
    },
    '/mehsul/': (context) {
      final arguments = ModalRoute.of(context)!.settings.arguments as List?;
      return SingleProductPage(slug: arguments?.isNotEmpty == true ? arguments![0] as String : null);
    },
  };

  static Map<String, Widget Function(BuildContext)> extraRoutes = {
    '/post/': (context) {
      final arguments = ModalRoute.of(context)!.settings.arguments as List?;
      return SingleCampaign(slug: arguments?.isNotEmpty == true ? arguments![0] as String : null);
    },
  };

  static Map<String, Widget Function(BuildContext)> generalRoutes = {...routes, ...extraRoutes};
}
