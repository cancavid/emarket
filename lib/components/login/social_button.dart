import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meqamax/classes/social_login.dart';
import 'package:meqamax/themes/theme.dart';

class SocialButton extends StatefulWidget {
  final String type;

  const SocialButton({super.key, required this.type});

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      final data = await _googleSignIn.signIn();
      if (data != null) {
        Map info = {'name': data.displayName, 'email': data.email, 'id': data.id, 'photo': data.photoUrl};
        await SocialLogin().socialLogin(data.id, 'Google', info);
      }
    } catch (error) {
      // print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    String icon = '';
    String text = '';

    if (widget.type == 'Google') {
      icon = 'assets/brands/google-login.svg';
      text = 'Google ilə qeydiyyat'.tr;
    } else {
      icon = 'assets/brands/facebook-login.svg';
      text = 'Facebook ilə qeydiyyat'.tr;
    }

    return GestureDetector(
      onTap: () async {
        if (widget.type == 'Google') {
          _handleSignIn();
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 60.0,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryBg,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              width: 1.0,
              color: Theme.of(context).colorScheme.grey3,
            )),
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 25.0),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(text, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
