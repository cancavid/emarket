import 'package:get/get.dart';
import 'package:meqamax/components/cart/cart_total.dart';
import 'package:meqamax/pages/ecommerce/checkout.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets/html.dart';
import 'package:flutter/material.dart';

class CartBottomNavigation extends StatefulWidget {
  final Map data;
  const CartBottomNavigation({super.key, required this.data});

  @override
  State<CartBottomNavigation> createState() => _CartBottomNavigationState();
}

class _CartBottomNavigationState extends State<CartBottomNavigation> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSize(
            duration: Duration(milliseconds: 150),
            alignment: Alignment.topCenter,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Visibility(
                  visible: visible,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Theme.of(context).colorScheme.grey4),
                          ),
                          color: Theme.of(context).colorScheme.secondaryBg),
                      child: CartTotal(cart: widget.data)),
                ))),
        Ink(
          color: Theme.of(context).colorScheme.secondaryBg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.data['error'] != '') ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  color: Colors.red,
                  child: MsHtml(
                    data: widget.data['error'],
                    color: Theme.of(context).colorScheme.secondaryBg,
                  ),
                )
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 17.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryColor, borderRadius: BorderRadius.circular(30.0)),
                              child: Icon(visible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.secondaryBg, size: 16.0),
                            ),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Toplam'.tr, style: Theme.of(context).textTheme.extraSmallTitle),
                                Text('${widget.data['final_price']} ${App.currency}', style: Theme.of(context).textTheme.smallHeading),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 30.0),
                    Expanded(
                      child: MsButton(
                        onTap: () {
                          Get.to(() => CheckoutPage());
                        },
                        title: 'Sifarişi tamamla'.tr,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
