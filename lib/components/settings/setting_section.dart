import 'package:meqamax/themes/theme.dart';
import 'package:flutter/material.dart';

class SettingSection extends StatelessWidget {
  final String title;
  final Widget child;
  const SettingSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 5.0, color: Theme.of(context).colorScheme.bg),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.extraSmallTitle),
            SizedBox(height: 5.0),
            child,
          ],
        ));
  }
}
