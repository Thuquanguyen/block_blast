import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../../services/storage_service.dart';
import '../../daily_reward/bindings/daily_reward_binding.dart';
import '../../daily_reward/views/daily_reward_dialog.dart';
import '../widgets/onboarding_dialog.dart';

class HomeController extends GetxController {
  HomeController(this._storageService);

  final StorageService _storageService;

  void playClassicGame() {
    if (_storageService.getTutorialCompleted()) {
      Get.toNamed(Routes.GAME);
      return;
    }
    Get.dialog(
      OnboardingDialog(
        onFinish: () {
          _storageService.saveTutorialCompleted(true);
          Get.back();
          Get.toNamed(Routes.GAME);
        },
      ),
      barrierDismissible: false,
    );
  }

  void openJourney() => Get.toNamed(Routes.JOURNEY);

  void openCollection() => Get.toNamed(Routes.COLLECTION);

  void openSettings() => Get.toNamed(Routes.SETTINGS);

  void openLeaderboard() => Get.toNamed(Routes.LEADERBOARD);

  void openDailyReward() {
    DailyRewardBinding().dependencies();
    Get.dialog(const DailyRewardDialog());
  }
}
