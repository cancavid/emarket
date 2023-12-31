import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool buttonLoading = false;
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  var loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  update() async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/users.php?action=password&lang=${Get.locale?.languageCode}"));

      request.fields['current'] = currentPassword;
      request.fields['new'] = newPassword;
      request.fields['confirm'] = confirmPassword;
      request.fields['user_id'] = loginController.userId.value;

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));

        if (mounted) {
          setState(() {
            buttonLoading = false;
            if (result['status'] == 'success') {
              currentPassword = '';
              newPassword = '';
              confirmPassword = '';
              _formKey.currentState!.reset();
              showSnackBar(context, result['result'], type: SnackBarTypes.success);
              Get.back();
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
      appBar: MsAppBar(title: 'Şifrə dəyişdirilməsi'.tr),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Şifrənizi dəyişdirmək istərmisinizsə, bu hissədə heç bir əməliyyat icra etməyin.'.tr, style: TextStyle(color: Theme.of(context).colorScheme.grey1)),
                    SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7.0),
                      child: Text('Hazırkı şifrəniz'.tr, style: Theme.of(context).textTheme.extraSmallTitle),
                    ),
                    TextFormField(
                      initialValue: currentPassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Hazırkı şifrənizi qeyd etməmisiniz.'.tr;
                        }
                        setState(() {
                          currentPassword = value;
                        });
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7.0),
                      child: Text('Yeni şifrə'.tr, style: Theme.of(context).textTheme.extraSmallTitle),
                    ),
                    TextFormField(
                      initialValue: newPassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Yeni şifrə qeyd etməmisiniz.'.tr;
                        }
                        setState(() {
                          newPassword = value;
                        });
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7.0),
                      child: Text('Yeni şifrənin təkrarı'.tr, style: Theme.of(context).textTheme.extraSmallTitle),
                    ),
                    TextFormField(
                      initialValue: confirmPassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Yeni şifrənizin təkrarını qeyd etməmisiniz.'.tr;
                        }
                        setState(() {
                          confirmPassword = value;
                        });
                        return null;
                      },
                    ),
                    const SizedBox(height: 25.0),
                    MsButton(
                        onTap: () {
                          if (_formKey.currentState!.validate() && buttonLoading == false) {
                            setState(() {
                              buttonLoading = true;
                            });
                            update();
                          }
                        },
                        loading: buttonLoading,
                        title: 'Yadda saxla'.tr)
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
