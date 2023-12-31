import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';

class ConfirmAccountPage extends StatefulWidget {
  final String userId;
  const ConfirmAccountPage({super.key, required this.userId});

  @override
  State<ConfirmAccountPage> createState() => _ConfirmAccountPageState();
}

class _ConfirmAccountPageState extends State<ConfirmAccountPage> {
  bool buttonLoading = false;
  String code = '';

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
  bool timeFinish = false;
  final loginController = Get.put(LoginController());

  void onEnd() {
    if (mounted) {
      setState(() {
        timeFinish = true;
      });
    }
  }

  confirm() async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/auth.php?action=confirm&lang=${Get.locale?.languageCode}"));

      request.fields['code'] = code;
      request.fields['user_id'] = widget.userId;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));

        if (mounted) {
          if (result['status'] == 'success') {
            loginController.update(true, result['result']);
            showSnackBar(context, 'Hesabınız təsdiqlənmişdir.'.tr, type: SnackBarTypes.success);
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

  resend() async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/auth.php?action=resend&lang=${Get.locale?.languageCode}"));

      request.fields['session_key'] = widget.userId;

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));

        if (mounted) {
          if (result['status'] == 'success') {
            showSnackBar(context, result['result'], type: SnackBarTypes.success);
          } else {
            showSnackBar(context, result['error']);
          }
        }
      } else {
        setState(() {
          showSnackBar(context, 'Serverlə əlaqə yaratmaq mümkün olmadı.'.tr);
        });
      }
    } else {
      setState(() {
        showSnackBar(context, 'İnternet bağlantısı problemi var.'.tr);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 20.0),
          children: [
            Text('Emailinizə gələn kodu daxil edin'.tr, style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 5.0),
            Text('Heç bir email almamısınızsa, "SPAM" qovluğuna nəzər yetirin'.tr, style: TextStyle(color: Theme.of(context).colorScheme.grey1)),
            SizedBox(height: 25.0),
            PinCodeTextField(
              enablePinAutofill: true,
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.none,
              dialogConfig: DialogConfig(
                dialogTitle: 'Buraya əlavə et'.tr,
                dialogContent: 'Kopyalanmış kodu əlavə etmək istəyirsiniz'.tr,
                affirmativeText: 'Daxil et'.tr,
                negativeText: 'İmtina'.tr,
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5.0),
                borderWidth: 1.0,
                fieldHeight: 50,
                fieldWidth: 45,
                selectedFillColor: Theme.of(context).colorScheme.secondaryBg,
                selectedColor: Theme.of(context).colorScheme.grey1,
                selectedBorderWidth: 1.0,
                activeFillColor: Theme.of(context).colorScheme.secondaryBg,
                activeColor: Theme.of(context).colorScheme.grey4,
                activeBorderWidth: 1.0,
                inactiveFillColor: Theme.of(context).colorScheme.secondaryBg,
                inactiveColor: Theme.of(context).colorScheme.grey3,
                inactiveBorderWidth: 1.0,
              ),
              animationDuration: Duration(milliseconds: 100),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              onCompleted: (value) {
                setState(() {
                  code = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  code = value;
                });
              },
              beforeTextPaste: (text) {
                return true;
              },
            ),
            SizedBox(height: 20.0),
            MsButton(
                onTap: () {
                  if (code.length == 6) {
                    setState(() {
                      buttonLoading = true;
                    });
                    confirm();
                  } else {
                    showSnackBar(context, 'Təsdiq kodunu tam qeyd etməmisiniz.'.tr);
                  }
                },
                loading: buttonLoading,
                title: 'Təsdiqlə'),
            SizedBox(height: 30.0),
            Text(
              'Hələ də email ala bilməmisinizsə, vaxt bitdikdən sonra təkrar istək göndərin.'.tr,
              style: TextStyle(color: Theme.of(context).colorScheme.grey1),
              textAlign: TextAlign.center,
            ),
            (timeFinish)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
                        timeFinish = false;
                      });
                      resend();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Təkrar göndər'.tr,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.link,
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      children: [
                        SizedBox(height: 15.0),
                        CountdownTimer(
                          endTime: endTime,
                          onEnd: onEnd,
                          widgetBuilder: (_, time) {
                            return Text('${time!.min ?? '00'} : ${time.sec.toString().padLeft(2, '0')}');
                          },
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
