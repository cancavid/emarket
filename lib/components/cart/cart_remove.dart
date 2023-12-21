import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class CartRemove extends StatelessWidget {
  final Function() onTap;
  const CartRemove({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 30.0,
          height: 30.0,
          padding: const EdgeInsets.all(7.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Theme.of(context).colorScheme.bg,
          ),
          child: Center(
            child: MsSvgIcon(icon: 'assets/interface/delete.svg', color: Colors.red),
          )),
    );
  }
}
