import 'package:meqamax/themes/theme.dart';
import 'package:flutter/material.dart';

class CartQuantity extends StatelessWidget {
  final Function() decrease;
  final Function() increase;
  final String quantity;
  const CartQuantity({super.key, required this.decrease, required this.increase, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: decrease,
          child: Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), border: Border.all(color: Theme.of(context).colorScheme.grey4)),
            child: Center(
                child: Text(
              '-',
              style: TextStyle(height: 0.0),
            )),
          ),
        ),
        SizedBox(
            width: 35.0,
            child: Text(
              quantity,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.0, height: 1.3),
            )),
        GestureDetector(
          onTap: increase,
          child: Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), border: Border.all(color: Theme.of(context).colorScheme.grey4)),
            child: Center(
                child: Text(
              '+',
              style: TextStyle(height: 0.0),
            )),
          ),
        ),
      ],
    );
  }
}
