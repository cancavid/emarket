import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/pages/ecommerce/single_taxonomy.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/image.dart';
import 'package:meqamax/widgets_extra/navigator.dart';

class HomeBrands extends StatefulWidget {
  final List brands;
  const HomeBrands({super.key, required this.brands});

  @override
  State<HomeBrands> createState() => _HomeBrandsState();
}

class _HomeBrandsState extends State<HomeBrands> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Populyar brendlər'.tr, style: Theme.of(context).textTheme.extraLargeHeading),
          SizedBox(height: 20.0),
          GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: widget.brands.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    navigatePage(
                      context,
                      SingleTaxonomyPage(
                        title: widget.brands[index]['term_name'],
                        brandId: widget.brands[index]['term_id'],
                      ),
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.bg,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: MsImage(
                        url: widget.brands[index]['term_thumbnail'],
                        fit: BoxFit.contain,
                      )),
                );
              }),
        ],
      ),
    );
  }
}
