import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController {
  RxMap languages = {'az': 'Azərbaycan dili', 'ru': 'Русский', 'en': 'English'}.obs;
  RxString lang = 'az'.obs;
  final box = GetStorage();

  void get() {
    box.writeIfNull('lang', 'az');
    lang.value = box.read('lang');
  }

  void update(value) {
    lang.value = value;
    box.write('lang', value);
    Get.updateLocale(Locale(lang.toString(), lang.toString().toUpperCase()));
  }
}
