import 'dart:convert';

import 'package:meqamax/components/form/label.dart';
import 'package:meqamax/components/login/separator.dart';
import 'package:meqamax/components/login/social_buttons.dart';
import 'package:meqamax/controllers/cart_controller.dart';
import 'package:meqamax/controllers/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/pages/login/forgot_password.dart';
import 'package:meqamax/pages/login/registration.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool buttonLoading = false;
  String username = '';
  String password = '';
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());
  final cartController = Get.put(CartController());
  final wishlistController = Get.put(WishlistController());

  login() async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/auth.php?action=login&lang=${Get.locale?.languageCode}"));

      request.fields['username'] = username;
      request.fields['password'] = password;

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));
        if (mounted) {
          setState(() {
            buttonLoading = false;
            if (result['status'] == 'success') {
              if (result['result']['user_status'].toString() == '1') {
                loginController.update(true, result['result']);
                cartController.get();
                wishlistController.get();
                Get.back();
              } else {
                showSnackBar(context, 'Hesabınız aktiv deyil.'.tr);
              }
            } else {
              showSnackBar(context, result['error']);
            }
          });
        }
      } else {
        setState(() {
          buttonLoading = false;
          showSnackBar(context, 'Serverlə əlaqə yaratmaq mümkün olmadı.'.tr);
        });
      }
    } else {
      setState(() {
        buttonLoading = false;
        showSnackBar(context, 'İnternet bağlantısı problemi var.'.tr);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryBg,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 20.0),
          children: [
            Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Xoş gəlmisiniz!'.tr, style: Theme.of(context).textTheme.extraLargeHeading),
                    SizedBox(height: 35.0),
                    FormLabel(label: 'Email'.tr),
                    TextFormField(
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(hintText: 'Email ünvanı'.tr),
                      initialValue: username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'İstifadəçi adı və ya email qeyd etməlisiniz.'.tr;
                        }
                        setState(() {
                          username = value;
                        });
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    FormLabel(label: 'Şifrə'.tr),
                    Stack(
                      children: [
                        TextFormField(
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(hintText: 'Hesab şifrəsi'.tr),
                          initialValue: password,
                          obscureText: !showPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Şifrə qeyd etməmisiniz.'.tr;
                            }
                            setState(() {
                              password = value;
                            });
                            return null;
                          },
                        ),
                        Positioned(
                            top: 5,
                            right: 0,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: MsSvgIcon(
                                  icon: (showPassword) ? 'assets/interface/eye-crossed.svg' : 'assets/interface/eye.svg',
                                  color: Theme.of(context).colorScheme.grey1,
                                ))),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return ForgotPassword();
                                  });
                            },
                            child: Text(
                              'Şifrənizi unutmusunuz?'.tr,
                              style: Theme.of(context).textTheme.link,
                            ))),
                    SizedBox(height: 40.0),
                    MsButton(
                        onTap: () {
                          if (_formKey.currentState!.validate() && buttonLoading == false) {
                            setState(() {
                              buttonLoading = true;
                            });
                            login();
                          }
                        },
                        loading: buttonLoading,
                        title: 'Daxil ol'.tr),
                    Column(
                      children: [
                        LoginSeparator(),
                        SocialButtons(),
                        SizedBox(height: 20.0),
                        Wrap(
                          runSpacing: 5.0,
                          spacing: 5.0,
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            Text('Sistem üzərində hesabınız yoxdur?'.tr, style: Theme.of(context).textTheme.bodySmall),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => RegistrationPage());
                              },
                              child: Text('Qeydiyyatdan keç'.tr, style: Theme.of(context).textTheme.link),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
