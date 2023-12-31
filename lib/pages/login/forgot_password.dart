import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/bottom_sheet_liner.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool buttonLoading = false;
  String username = '';
  final _formKey = GlobalKey<FormState>();

  reset() async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/auth.php?action=reset&lang=${Get.locale?.languageCode}"));

      request.fields['username'] = username;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));

        if (mounted) {
          if (result['status'] == 'success') {
            setState(() {
              buttonLoading = false;
              showSnackBar(context, result['result'], type: SnackBarTypes.success, duration: Duration(seconds: 15));
            });
            Get.back();
          } else {
            setState(() {
              buttonLoading = false;
              showSnackBar(context, result['error']);
            });
          }
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
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .8,
      maxChildSize: .8,
      minChildSize: .2,
      builder: (_, controller) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            controller: controller,
            children: [
              MsBottomSheetLiner(),
              Form(
                key: _formKey,
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      Text('Şifrənizi unutmusunuz?'.tr, style: Theme.of(context).textTheme.extraLargeHeading),
                      SizedBox(height: 15.0),
                      Text('Aşağıdakı hissəyə email ünvanınızı daxil edərək şifrənizi sıfırlayın'.tr, style: TextStyle(color: Theme.of(context).colorScheme.grey1)),
                      SizedBox(height: 25.0),
                      TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: MsSvgIcon(
                              icon: 'assets/interface/at.svg',
                              color: Theme.of(context).colorScheme.grey1,
                            ),
                            hintText: 'Email'),
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
                      SizedBox(height: 20.0),
                      MsButton(
                          onTap: () {
                            if (_formKey.currentState!.validate() && buttonLoading == false) {
                              setState(() {
                                buttonLoading = true;
                              });
                              reset();
                            }
                          },
                          loading: buttonLoading,
                          title: 'Sıfırla'.tr)
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
