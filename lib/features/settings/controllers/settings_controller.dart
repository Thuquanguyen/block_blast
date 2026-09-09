import 'package:get/get.dart';

import '../../../services/iap_service.dart';
import '../../../services/storage_service.dart';

class SettingsController extends GetxController {
  SettingsController(this._storageService, this._iapService);

  final StorageService _storageService;
  final IapService _iapService;

  late final RxBool soundEnabled;
  late final RxBool musicEnabled;
  late final RxBool hapticEnabled;
  late final RxString nickname;

  RxBool get removeAds => _iapService.removeAds;

  @override
  void onInit() {
    super.onInit();
    soundEnabled = _storageService.getSoundEnabled().obs;
    musicEnabled = _storageService.getMusicEnabled().obs;
    hapticEnabled = _storageService.getHapticEnabled().obs;
    nickname = _storageService.getNickname().obs;
  }

  void toggleSound(bool value) {
    soundEnabled.value = value;
    _storageService.saveSoundEnabled(value);
  }

  void toggleMusic(bool value) {
    musicEnabled.value = value;
    _storageService.saveMusicEnabled(value);
  }

  void toggleHaptic(bool value) {
    hapticEnabled.value = value;
    _storageService.saveHapticEnabled(value);
  }

  void updateNickname(String value) {
    nickname.value = value;
    _storageService.saveNickname(value);
  }

  void removeAdsTapped() => _iapService.purchaseRemoveAds();

  void restorePurchaseTapped() => _iapService.restorePurchases();
}
