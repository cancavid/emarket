import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/form/label.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/behaviour.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:meqamax/widgets/snackbar.dart';
import 'package:http/http.dart' as http;

class AddCommentPage extends StatefulWidget {
  final String id;
  const AddCommentPage({super.key, required this.id});

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  String name = '';
  String email = '';
  int rating = 0;
  String comment = '';
  String userId = '';

  bool success = false;
  bool buttonLoading = false;
  Map data = {};

  final loginController = Get.put(LoginController());

  send() async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/comments.php?action=add&lang=${Get.locale?.languageCode}"));

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['rating'] = rating.toString();
      request.fields['comment'] = comment;
      request.fields['post_id'] = widget.id;
      request.fields['user_id'] = userId;

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
  void initState() {
    super.initState();
    if (loginController.login.value) {
      name = '${loginController.userdata['first_name']} ${loginController.userdata['last_name']}';
      email = loginController.userdata['user_email'];
      userId = loginController.userId.value;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Şərh bildirin'.tr),
      body: Form(
          key: _formKey,
          child: (success)
              ? MsNotify(heading: data['result'], type: MsNotifyTypes.success)
              : ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 25.0),
                    children: [
                      if (!loginController.login.value) ...[
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
                      ],
                      FormLabel(label: 'Qiymətləndirmə'.tr),
                      Row(
                        children: [
                          for (var i = 1; i <= 5; i++) ...[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  rating = i;
                                });
                              },
                              child: Icon(
                                Icons.star,
                                color: (rating >= i) ? Colors.orange : Colors.grey.withOpacity(.3),
                              ),
                            )
                          ]
                        ],
                      ),
                      SizedBox(height: 15.0),
                      FormLabel(label: 'Şərh'.tr),
                      TextFormField(
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Heç bir şərh qeyd etməmisiniz.'.tr;
                          }
                          setState(() {
                            comment = value;
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
