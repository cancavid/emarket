import 'package:meqamax/themes/theme.dart';
import 'package:flutter/material.dart';

class FormLabel extends StatelessWidget {
  final String label;
  const FormLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7.0),
      child: Text(label, style: Theme.of(context).textTheme.extraSmallTitle),
    );
  }
}
