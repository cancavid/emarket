import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DarkModeController {
  RxString mode = 'System'.obs;
  RxMap modes = {'System': 'Sistemə uyğun', 'Light': 'Aydınlıq rejim', 'Dark': 'Qaranlıq rejim'}.obs;

  final box = GetStorage();

  void get() {
    box.writeIfNull('mode', 'System');
    mode.value = box.read('mode');
  }

  void update(data) {
    mode.value = data;
    box.write('mode', data);
    if (data == 'System') {
      Get.changeThemeMode(ThemeMode.light);
    } else if (data == 'Light') {
      Get.changeThemeMode(ThemeMode.light);
    } else if (data == 'Dark') {
      Get.changeThemeMode(ThemeMode.dark);
    }
  }
}
