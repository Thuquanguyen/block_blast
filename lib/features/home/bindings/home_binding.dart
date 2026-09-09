import 'package:get/get.dart';

import '../../../services/storage_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<StorageService>()),
    );
  }
}
