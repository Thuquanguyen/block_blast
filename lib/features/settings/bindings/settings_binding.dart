import 'package:get/get.dart';

import '../../../services/iap_service.dart';
import '../../../services/storage_service.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        Get.find<StorageService>(),
        Get.find<IapService>(),
      ),
    );
  }
}
