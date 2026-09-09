import 'package:get/get.dart';

import '../../../services/ad_service.dart';
import '../../../services/analytics_service.dart';
import '../../../services/haptic_service.dart';
import '../../../services/leaderboard_service.dart';
import '../../../services/storage_service.dart';
import '../controllers/game_controller.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameController>(
      () => GameController(
        Get.find<StorageService>(),
        Get.find<HapticService>(),
        Get.find<AnalyticsService>(),
        Get.find<AdService>(),
        Get.find<LeaderboardService>(),
      ),
    );
  }
}
