import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/themes/theme.dart';

class LoginSeparator extends StatelessWidget {
  const LoginSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0),
        Stack(
          children: [
            Divider(height: 30.0),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  color: Theme.of(context).colorScheme.secondaryBg,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text('və ya alternativ olaraq'.tr, style: Theme.of(context).textTheme.bodySmall),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
