import 'package:meqamax/components/cart/cart_quantity.dart';
import 'package:meqamax/components/cart/cart_remove.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItem extends StatelessWidget {
  final Map data;
  final Function(String, String, String) increase;
  final Function(String, String, String) decrease;
  final Function(String, String) remove;
  final bool variation;
  const CartItem({super.key, required this.data, required this.increase, required this.decrease, required this.remove, required this.variation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      color: Theme.of(context).colorScheme.secondaryBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: MsImage(url: data['data']['product_thumbnail'], width: 100.0, height: 140.0, pColor: Theme.of(context).colorScheme.bg),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: SizedBox(
              height: 140.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['data']['post_title'],
                    style: Theme.of(context).textTheme.smallHeading,
                    maxLines: 2,
                  ),
                  if (data['data']['variation_name'] != '') ...[
                    SizedBox(height: 8.0),
                    Text(
                      data['data']['variation_name'],
                      style: GoogleFonts.inter(fontSize: 11.0, height: 1, color: Theme.of(context).colorScheme.grey2),
                      maxLines: 1,
                    ),
                  ],
                  SizedBox(height: 8.0),
                  if (variation) ...[
                    displayPrice(data['data'], variation: true),
                  ] else ...[
                    displayPrice(data['data']),
                  ],
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CartQuantity(
                        decrease: () {
                          decrease(data['cart_product_id'].toString(), data['cart_variation_id'].toString(), data['cart_date']);
                        },
                        increase: () {
                          increase(data['cart_product_id'].toString(), data['cart_variation_id'].toString(), data['cart_date']);
                        },
                        quantity: data['cart_quantity'].toString(),
                      ),
                      CartRemove(onTap: () {
                        remove(data['cart_product_id'].toString(), data['cart_variation_id'].toString());
                      })
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
