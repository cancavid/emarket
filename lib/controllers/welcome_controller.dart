import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WelcomeController {
  RxBool welcome = true.obs;
  final box = GetStorage();
  void get() {
    box.writeIfNull('welcome', true);
    welcome.value = box.read('welcome');
  }

  void update(data) {
    welcome.value = data;
    box.write('welcome', data);
  }
}
