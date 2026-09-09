import 'package:get/get.dart';

import '../../../services/analytics_service.dart';
import '../../../services/storage_service.dart';
import '../controllers/daily_reward_controller.dart';

class DailyRewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyRewardController>(
      () => DailyRewardController(
        Get.find<StorageService>(),
        Get.find<AnalyticsService>(),
      ),
    );
  }
}
