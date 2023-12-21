import 'dart:convert';

import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/cart/cart_total.dart';
import 'package:meqamax/components/form/label.dart';
import 'package:meqamax/controllers/cart_controller.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/pages/ecommerce/order_details.dart';
import 'package:meqamax/pages/ecommerce/payment.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets/notify.dart';
import 'package:meqamax/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool serverError = false;
  bool connectError = false;
  bool buttonLoading = false;
  bool visible = false;

  String firstName = '';
  String lastName = '';
  String phone = '';
  String address = '';
  String email = '';
  String note = '';
  String method = 'offline';

  final loginController = Get.put(LoginController());
  final cartController = Get.put(CartController());
  final _formKey = GlobalKey<FormState>();

  order() async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/checkout.php?session_key=${loginController.userId}&lang=${Get.locale?.languageCode}"));

      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['address'] = address;
      request.fields['phone'] = phone;
      request.fields['email'] = email;
      request.fields['note'] = note;
      request.fields['payment_method'] = method;
      request.fields['appmode'] = '1';

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = json.decode(utf8.decode(responseData));

      if (result['status'] == 'success') {
        if (method == 'offline') {
          Get.close(1);
          Get.to(() => OrderDetailsPage(orderId: result['result']['id']), transition: Transition.fade);
        } else {
          Get.to(() => PaymentPage(url: result['result']['url']));
        }
      } else {
        setState(() {
          showSnackBar(context, result['error']);
        });
      }
      setState(() {
        buttonLoading = false;
      });
    } else {
      setState(() {
        showSnackBar(context, 'İnternet bağlantınız yoxdur.');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    firstName = 'Cavid';
    lastName = 'Muradov';
    phone = '055 508 58 64';
    address = 'Bakı';
    email = 'cavimur@gmail.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Sifarişi tamamla'.tr),
      bottomNavigationBar: (cartController.data['error'] != '')
          ? SizedBox()
          : Obx(() => Column(mainAxisSize: MainAxisSize.min, children: [
                AnimatedSize(
                    duration: Duration(milliseconds: 150),
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Visibility(
                          visible: visible,
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Theme.of(context).colorScheme.grey4),
                                  ),
                                  color: Theme.of(context).colorScheme.secondaryBg),
                              child: CartTotal(cart: cartController.data)),
                        ))),
                Ink(
                  color: Theme.of(context).colorScheme.secondaryBg,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  visible = !visible;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryColor, borderRadius: BorderRadius.circular(30.0)),
                                      child: Icon((visible) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.secondaryBg, size: 16.0),
                                    ),
                                    SizedBox(width: 10.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Toplam'.tr, style: Theme.of(context).textTheme.extraSmallTitle),
                                        Text('${cartController.data['final_price']} ${App.currency}', style: Theme.of(context).textTheme.extraSmallHeading),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 30.0),
                            Expanded(
                                child: MsButton(
                              onTap: () {
                                if (_formKey.currentState!.validate() && !buttonLoading) {
                                  setState(() {
                                    buttonLoading = true;
                                  });
                                  order();
                                }
                              },
                              title: 'Sifarişi təsdiqlə'.tr,
                              loading: buttonLoading,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ])),
      body: (cartController.data['error'] != '')
          ? MsNotify(
              heading: 'Səbətinizdə düzəldilməsi vacib məqamlar var.'.tr,
              action: () {
                Navigator.pop(context);
              },
              actionText: 'Səbətə qayıt'.tr,
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  FormLabel(label: 'Adınız'.tr),
                  TextFormField(
                    initialValue: firstName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Adınızı qeyd etməmisiniz.'.tr;
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
                    initialValue: lastName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Soyadınızı qeyd etməmisiniz.'.tr;
                      }
                      setState(() {
                        lastName = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  FormLabel(label: 'Telefon'.tr),
                  TextFormField(
                    initialValue: phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Telefon qeyd etməmisiniz.'.tr;
                      }
                      setState(() {
                        phone = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  FormLabel(label: 'Çatdırılma ünvanı'.tr),
                  TextFormField(
                    initialValue: address,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Çatdırılma ünvanı qeyd etməmisiniz.'.tr;
                      }
                      setState(() {
                        address = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  FormLabel(label: 'Email'.tr),
                  TextFormField(
                    initialValue: email,
                    validator: (value) {
                      if (value != '' && !GetUtils.isEmail(value!.trim())) {
                        return 'Email qeyd etməmisiniz.'.tr;
                      }
                      setState(() {
                        email = value!;
                      });
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  FormLabel(label: 'Əlavə qeydiniz'.tr),
                  TextFormField(
                    initialValue: note,
                    validator: (value) {
                      setState(() {
                        note = value!;
                      });
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  FormLabel(label: 'Ödəniş forması'.tr),
                  RadioListTile(
                      title: Text('Qapıda nağd ödəniş'.tr),
                      value: 'offline',
                      groupValue: method,
                      contentPadding: EdgeInsets.all(0),
                      onChanged: (value) {
                        setState(() {
                          method = value!;
                        });
                      }),
                  RadioListTile(
                      title: Text('Onlayn ödəniş'.tr),
                      value: 'online',
                      groupValue: method,
                      contentPadding: EdgeInsets.all(0),
                      onChanged: (value) {
                        setState(() {
                          method = value!;
                        });
                      })
                ],
              )),
    );
  }
}
