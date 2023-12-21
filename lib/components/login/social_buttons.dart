import 'package:get/get.dart';
import 'package:meqamax/components/login/social_button.dart';
import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialButton(type: 'Google'.tr),
        SizedBox(height: 15.0),
        SocialButton(type: 'Facebook'.tr),
      ],
    );
  }
}
