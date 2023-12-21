import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class SingleProductBottom extends StatefulWidget {
  final String stock;
  final int quantity;
  final Function quantityAction;
  final Function addToCartAction;
  final bool buttonLoading;
  const SingleProductBottom({
    super.key,
    required this.stock,
    required this.quantity,
    required this.quantityAction,
    required this.addToCartAction,
    required this.buttonLoading,
  });

  @override
  State<SingleProductBottom> createState() => _SingleProductBottomState();
}

class _SingleProductBottomState extends State<SingleProductBottom> {
  @override
  Widget build(BuildContext context) {
    return (widget.stock == '0')
        ? SizedBox()
        : Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryBg,
              border: Border(
                bottom: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.grey4),
                top: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.grey4),
              ),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.quantityAction('decrease');
                      },
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.grey3),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: MsSvgIcon(
                          icon: 'assets/interface/minus.svg',
                          size: 13.0,
                          color: Theme.of(context).colorScheme.text,
                        ),
                      ),
                    ),
                    Container(
                      width: 40.0,
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        widget.quantity.toString(),
                        style: TextStyle(height: 1.2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.quantityAction('increase');
                      },
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.grey3),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: MsSvgIcon(
                          icon: 'assets/interface/plus.svg',
                          size: 13.0,
                          color: Theme.of(context).colorScheme.text,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 30.0),
                Expanded(
                    child: MsButton(
                        onTap: () {
                          widget.addToCartAction();
                        },
                        title: 'Səbətə at'.tr,
                        loading: widget.buttonLoading)),
              ],
            ),
          );
  }
}
