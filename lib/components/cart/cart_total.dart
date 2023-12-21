import 'package:get/get.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartTotal extends StatelessWidget {
  final Map cart;
  const CartTotal({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          if (cart['display_sale'] != '') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Toplam qiymət:'.tr), Text('${cart['main_price']} ${App.currency}')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Endirim:'.tr),
                Text(
                  cart['display_sale'],
                  style: TextStyle(color: const Color.fromARGB(255, 194, 120, 10), fontSize: 13.0),
                ),
              ],
            ),
            Divider(height: 30.0, thickness: 1.0),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Yekun qiymət:'.tr,
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15.0),
              ),
              Text('${cart['final_price']} ${App.currency}', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15.0))
            ],
          )
        ],
      ),
    );
  }
}
