import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/form/label.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String name = '';
  String email = '';
  String message = '';
  String recaptchaKey = '';

  bool success = false;
  bool buttonLoading = false;
  Map data = {};

  send() async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/form.php?form_type=contact&lang=${Get.locale?.languageCode}"));

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['message'] = message;
      request.fields['g-recaptcha-response'] = recaptchaKey;

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));
        if (mounted) {
          if (result['status'] == 'success') {
            setState(() {
              buttonLoading = false;
              success = true;
              data = result;
            });
          } else if (result['status'] == 'error') {
            setState(() {
              buttonLoading = false;
              showSnackBar(context, result['errors']);
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
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Mesaj göndərin'.tr),
      body: Form(
          key: _formKey,
          child: (success)
              ? MsNotify(heading: data['result'], type: MsNotifyTypes.success)
              : ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 25.0),
                    children: [
                      Text(
                        'Əlavə sual və təkliflərinizlə bağlı aşağıdakı formdan bizə yaza bilərsiniz. Ən qısa zamanda əməkdaşlarımız sizə geri dönüş edəcəklər.'.tr,
                        style: TextStyle(fontSize: 14.0, color: Theme.of(context).colorScheme.grey1, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30.0),
                      FormLabel(label: 'Ad və soyadınız'.tr),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ad və soyadınızı qeyd etməmisiniz.'.tr;
                          }
                          setState(() {
                            name = value;
                          });
                          return null;
                        },
                      ),
                      SizedBox(height: 15.0),
                      FormLabel(label: 'Email'.tr),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email qeyd etməmisiniz.'.tr;
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
                      FormLabel(label: 'Mesajınız'.tr),
                      TextFormField(
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Heç bir mesaj qeyd etməmisiniz.'.tr;
                          }
                          setState(() {
                            message = value;
                          });
                          return null;
                        },
                      ),
                      SizedBox(height: 15.0),
                      MsButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate() && buttonLoading == false) {
                              setState(() {
                                buttonLoading = true;
                              });
                              send();
                            }
                          },
                          loading: buttonLoading,
                          title: 'Göndər'.tr),
                    ],
                  ),
                )),
    );
  }
}
