import 'package:get/get.dart';

class TabBarController {
  RxInt index = 0.obs;

  update(value) {
    index.value = value;
  }
}
