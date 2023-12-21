import 'package:meqamax/components/settings/bottomSheets/contact.dart';
import 'package:meqamax/components/settings/bottomSheets/languages.dart';
import 'package:meqamax/components/settings/logout_alert.dart';
import 'package:meqamax/components/settings/setting_section.dart';
import 'package:meqamax/pages/general/campaigns.dart';
import 'package:meqamax/pages/login/login.dart';
import 'package:meqamax/pages/ecommerce/orders.dart';
import 'package:meqamax/pages/login/registration.dart';
import 'package:meqamax/pages/general/stores.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meqamax/widgets/navigator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:meqamax/components/settings/bottomSheets/darkmode.dart';
import 'package:meqamax/components/settings/setting_item.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/pages/general/about.dart';
import 'package:meqamax/pages/login/change_password.dart';
import 'package:meqamax/pages/general/faq.dart';
import 'package:meqamax/pages/login/userinfo.dart';
import 'package:meqamax/pages/general/message.dart';
import 'package:meqamax/pages/general/policy.dart';
import 'package:meqamax/widgets/behaviour.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();

    loginController.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Parametrlər'.tr),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          children: [
            Ink(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryBg),
                child: Column(
                  children: [
                    Obx(() => (loginController.login.value)
                        ? SettingSection(
                            title: 'Mənim hesabım'.tr,
                            child: Column(
                              children: [
                                SettingItem(title: 'Sifarişləriniz'.tr, image: 'assets/interface/orders.svg', onTap: () => Get.to(() => OrdersPage())),
                                SettingItem(title: 'Şəxsi məlumatlarınız'.tr, image: 'assets/interface/edit-user.svg', onTap: () => Get.to(() => UserInfoPage())),
                                SettingItem(title: 'Şifrə dəyişdirmək'.tr, image: 'assets/interface/password.svg', onTap: () => Get.to(() => ChangePasswordPage()), border: false),
                              ],
                            ))
                        : Ink(
                            color: Theme.of(context).colorScheme.bg,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: MsButton(
                                  onTap: () {
                                    Get.to(() => RegistrationPage());
                                  },
                                  title: 'Qeydiyyat'.tr,
                                  style: MsButtonStyle.primary,
                                  borderRadius: 10.0,
                                  textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white, height: 1.3),
                                )),
                                SizedBox(width: 15.0),
                                Expanded(
                                    child: MsButton(
                                  onTap: () {
                                    Get.to(() => LoginPage());
                                  },
                                  title: 'Daxil ol'.tr,
                                  style: MsButtonStyle.secondary,
                                  borderRadius: 10.0,
                                  textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white, height: 1.3),
                                )),
                              ],
                            ),
                          )),
                    SettingSection(
                        title: 'Tətbiq parametrləri'.tr,
                        child: Column(
                          children: [
                            SettingItem(
                                title: 'Qaranlıq rejim'.tr,
                                image: 'assets/interface/darkmode.svg',
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return DarkModeBottomSheet();
                                      });
                                }),
                            SettingItem(
                                title: 'Bildirişlər'.tr,
                                image: 'assets/interface/bell.svg',
                                onTap: () {
                                  openAppSettings();
                                }),
                            SettingItem(
                              title: 'İnterfeys dili'.tr,
                              image: 'assets/interface/translate.svg',
                              border: false,
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return LanguageBottomSheet();
                                    });
                              },
                            ),
                          ],
                        )),
                    SettingSection(
                        title: 'Bizim haqqımızda'.tr,
                        child: Column(
                          children: [
                            SettingItem(title: 'Kampaniyalar'.tr, image: 'assets/interface/sale.svg', onTap: () => navigatePage(context, CampaignsPage(), root: true)),
                            SettingItem(title: 'Haqqımızda'.tr, image: 'assets/interface/info.svg', onTap: () => navigatePage(context, AboutPage(), root: true)),
                            SettingItem(title: 'Ən çox soruşulan suallar'.tr, image: 'assets/interface/faq.svg', onTap: () => navigatePage(context, FaqPage(), root: true)),
                            SettingItem(title: 'Məxfilik siyasəti'.tr, image: 'assets/interface/security.svg', onTap: () => navigatePage(context, PolicyPage(), root: true)),
                            SettingItem(title: 'Bizə yazın'.tr, image: 'assets/interface/message.svg', onTap: () => navigatePage(context, MessagePage(), root: true)),
                            SettingItem(title: 'Mağazalarımız'.tr, image: 'assets/interface/location.svg', onTap: () => navigatePage(context, StoresPage(), root: true)),
                            SettingItem(
                                title: 'Bizimlə əlaqə'.tr,
                                image: 'assets/interface/contact.svg',
                                border: false,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return ContactBottomSheet();
                                      });
                                }),
                          ],
                        )),
                    Obx(() => (loginController.login.value)
                        ? SettingSection(
                            title: 'Digər'.tr,
                            child: SettingItem(
                                title: 'Çıxış'.tr,
                                image: 'assets/interface/logout.svg',
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return LogoutAlert();
                                    },
                                  );
                                },
                                border: false),
                          )
                        : SizedBox())
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
