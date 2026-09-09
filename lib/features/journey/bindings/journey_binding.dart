import 'package:get/get.dart';

import '../../../services/analytics_service.dart';
import '../../../services/storage_service.dart';
import '../controllers/journey_controller.dart';

class JourneyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JourneyController>(
      () => JourneyController(
        Get.find<AnalyticsService>(),
        Get.find<StorageService>(),
      ),
    );
  }
}
