import 'package:get/get.dart';

import '../controllers/account_edit_controller.dart';

class AccountEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountEditController>(
      () => AccountEditController(),
    );
  }
}
