import 'dart:convert';
import 'dart:io';

import 'package:meqamax/components/form/label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/components/login/profile_picture_edit.dart';
import 'package:meqamax/components/settings/profile_image.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/alphabet.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  double imageSize = 150.0;
  bool loading = true;
  bool buttonLoading = false;
  Map data = {};
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String address = '';
  File? _image;
  bool deleteImage = false;

  var loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  var maskFormatter = MaskTextInputFormatter(mask: '(###) ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  Future getImage(source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  void deleteProfilePicture() {
    setState(() {
      _image = null;
      data['profile_image'] = null;
      deleteImage = true;
    });
  }

  void selectFromGallery() {
    setState(() {
      deleteImage = false;
    });
    getImage(ImageSource.gallery);
  }

  void openCamera() {
    setState(() {
      deleteImage = false;
    });
    getImage(ImageSource.camera);
  }

  update() async {
    if (await checkConnectivity()) {
      var request = http.MultipartRequest("POST", Uri.parse("${App.domain}/api/users.php?action=update&lang=${Get.locale?.languageCode}"));

      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['user_email'] = email;
      request.fields['phone'] = phone;
      request.fields['address'] = address;
      request.fields['delete_image'] = deleteImage.toString();
      request.fields['user_id'] = loginController.userId.value;

      if (_image != null && deleteImage == false) {
        request.files.add(http.MultipartFile.fromBytes('profile_image', File(_image!.path).readAsBytesSync(), filename: _image!.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));
        if (mounted) {
          if (result['status'] == 'success') {
            showSnackBar(context, result['result']['message'], type: SnackBarTypes.success);
            loginController.get();
            Get.back();
          } else {
            showSnackBar(context, result['error']);
          }
          setState(() {
            buttonLoading = false;
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
  void initState() {
    super.initState();
    loginController.get();
    setState(() {
      if (loginController.userdata.isNotEmpty) {
        firstName = loginController.userdata['first_name'] ?? '';
        lastName = loginController.userdata['last_name'] ?? '';
        email = loginController.userdata['user_email'] ?? '';
        phone = loginController.userdata['phone'] ?? '';
        address = loginController.userdata['address'] ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Şəxsi məlumatlarınız'.tr),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 30.0),
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    (_image != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(imageSize),
                            child: Image.file(
                              _image!,
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.cover,
                            ))
                        : (deleteImage)
                            ? AlphabetPP(data: loginController.userdata, size: 150.0, fontSize: 35.0)
                            : ProfilePicture(data: loginController.userdata, size: 150.0),
                    Positioned.fill(
                        bottom: 0.0,
                        right: 0.0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryColor,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: 150.0,
                                          child: ProfilePictureEditBottomSheet(
                                            delete: deleteProfilePicture,
                                            gallery: selectFromGallery,
                                            camera: openCamera,
                                          ),
                                        );
                                      });
                                },
                                child: Text('Dəyişdir'.tr, style: TextStyle(color: Theme.of(context).colorScheme.secondaryBg, fontSize: 12.0, height: 1.3))),
                          ),
                        )),
                  ],
                )),
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
            FormLabel(label: 'Email'.tr),
            TextFormField(
              initialValue: email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email qeyd etməmisiniz.'.tr;
                } else if (!GetUtils.isEmail(value)) {
                  return 'Email düzgün deyil.'.tr;
                }
                setState(() {
                  email = value;
                });
                return null;
              },
            ),
            SizedBox(height: 15.0),
            FormLabel(label: 'Telefon'.tr),
            TextFormField(
              keyboardType: TextInputType.phone,
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
              minLines: 1,
              maxLines: 4,
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
            SizedBox(height: 25.0),
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
                title: 'Yadda saxla'.tr),
          ],
        ),
      ),
    );
  }
}
