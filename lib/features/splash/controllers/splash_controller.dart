import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../../app/widgets/force_update_dialog.dart';
import '../../../services/remote_config_service.dart';
import '../../../services/storage_service.dart';
import '../../home/widgets/onboarding_dialog.dart';

class SplashController extends GetxController {
  static const _splashDuration = Duration(seconds: 2);

  @override
  void onReady() {
    super.onReady();
    Future.delayed(_splashDuration, () {
      if (Get.find<RemoteConfigService>().isUpdateRequired) {
        Get.dialog(const ForceUpdateDialog(), barrierDismissible: false);
        return;
      }
      // Establish Home as the base route (so the in-game back arrow and
      // any later menu navigation still work), then immediately push
      // straight into Classic Game — the player shouldn't have to tap
      // anything on Home just to start playing.
      Get.offAllNamed(Routes.HOME);
      _enterClassicGame();
    });
  }

  void _enterClassicGame() {
    final storageService = Get.find<StorageService>();
    if (storageService.getTutorialCompleted()) {
      Get.toNamed(Routes.GAME);
      return;
    }
    Get.dialog(
      OnboardingDialog(
        onFinish: () {
          storageService.saveTutorialCompleted(true);
          Get.back();
          Get.toNamed(Routes.GAME);
        },
      ),
      barrierDismissible: false,
    );
  }
}
