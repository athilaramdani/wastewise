import 'package:get/get.dart';

import '../controllers/wisebot_controller.dart';

class WisebotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WisebotController>(
      () => WisebotController(),
    );
  }
}
