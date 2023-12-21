import 'package:get/get.dart';

class StoryController {
  RxBool animate = false.obs;
  RxDouble width = 0.0.obs;
  RxInt duration = 0.obs;

  update() {
    width.value = 0.0;
    duration.value = 0;
    Future.delayed(Duration(milliseconds: 100), () {
      width.value = Get.width;
      duration.value = 3900;
    });
  }
}
