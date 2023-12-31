import 'dart:convert';

import 'package:meqamax/components/form/label.dart';
import 'package:meqamax/components/login/social_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/login/separator.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/pages/login/confirm_account.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool buttonLoading = false;
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());

  registration() async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/auth.php?action=registration&lang=${Get.locale?.languageCode}"));

      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['user_email'] = email;
      request.fields['user_password'] = password;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));

        if (mounted) {
          setState(() {
            buttonLoading = false;
            if (result['status'] == 'success') {
              Get.off(() => ConfirmAccountPage(userId: result['result']['user_id'].toString()));
            } else {
              setState(() {
                buttonLoading = false;
                showSnackBar(context, result['error']);
              });
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
      body: Form(
          key: _formKey,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 20.0),
              children: [
                Text('Yeni hesab yaradın'.tr, style: Theme.of(context).textTheme.extraLargeHeading),
                SizedBox(height: 35.0),
                SocialButtons(),
                LoginSeparator(),
                FormLabel(label: 'Adınız'.tr),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Adınız'.tr),
                  initialValue: firstName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Adınızı qeyd etməlisiniz.'.tr;
                    }
                    setState(() {
                      firstName = value;
                    });
                    return null;
                  },
                ),
                SizedBox(height: 15.0),
                FormLabel(label: 'Soyadınız'.tr),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Soyadınız'.tr),
                  initialValue: lastName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Soyadınızı qeyd etməlisiniz.'.tr;
                    }
                    setState(() {
                      lastName = value;
                    });
                    return null;
                  },
                ),
                SizedBox(height: 15.0),
                FormLabel(label: 'Email'.tr),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Email ünvanı'.tr),
                  initialValue: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email qeyd etməlisiniz.'.tr;
                    } else if (!GetUtils.isEmail(value.trim())) {
                      return 'Email düzgün deyil.'.tr;
                    }
                    setState(() {
                      email = value;
                    });
                    return null;
                  },
                ),
                SizedBox(height: 15.0),
                FormLabel(label: 'Şifrə'.tr),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Şifrə'.tr),
                  initialValue: password,
                  obscureText: true,
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
                SizedBox(height: 15.0),
                FormLabel(label: 'Şifrənin təkrarı'.tr),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Şifrənin təkrarı'.tr),
                  initialValue: confirmPassword,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifrənizin təkrarını qeyd etməmisiniz.'.tr;
                    } else if (value != password) {
                      return 'Şifrəniz təkrarı ilə eyni deyil.'.tr;
                    }
                    setState(() {
                      confirmPassword = value;
                    });
                    return null;
                  },
                ),
                SizedBox(height: 30.0),
                MsButton(
                    onTap: () {
                      if (_formKey.currentState!.validate() && buttonLoading == false) {
                        setState(() {
                          buttonLoading = true;
                        });
                        registration();
                      }
                    },
                    loading: buttonLoading,
                    title: 'Qeydiyyatdan keç'.tr),
                SizedBox(height: 20.0),
                Column(
                  children: [
                    Wrap(
                      runSpacing: 5.0,
                      spacing: 5.0,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        Text('Artıq qeydiyyatdan keçmisiniz?'.tr, style: Theme.of(context).textTheme.bodySmall),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text('Daxil ol'.tr, style: Theme.of(context).textTheme.link),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
