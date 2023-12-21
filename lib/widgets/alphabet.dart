import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';

class AlphabetPP extends StatelessWidget {
  final Map data;
  final double size;
  final double fontSize;

  const AlphabetPP({super.key, required this.data, this.size = 56.0, this.fontSize = 18.0});

  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty) {
      String first = data['first_name'].substring(0, 1);
      String last = data['last_name'].substring(0, 1);
      return Container(
        alignment: Alignment.center,
        width: size,
        height: size,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryColor, borderRadius: BorderRadius.circular(size)),
        child: Text('$first$last'.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w600, height: 1.2)),
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(size), color: Theme.of(context).colorScheme.oppositeText),
        child: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.secondaryColor, size: size),
      );
    }
  }
}
