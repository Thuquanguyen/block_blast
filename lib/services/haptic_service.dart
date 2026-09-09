import 'package:flutter/services.dart';

import 'storage_service.dart';

/// Thin wrapper around [HapticFeedback], gated on the user's haptic setting.
class HapticService {
  HapticService(this._storageService);

  final StorageService _storageService;

  void placeBlock() {
    if (!_storageService.getHapticEnabled()) return;
    HapticFeedback.lightImpact();
  }

  void rotateBlock() {
    if (!_storageService.getHapticEnabled()) return;
    HapticFeedback.lightImpact();
  }

  void lineClearOrCombo() {
    if (!_storageService.getHapticEnabled()) return;
    HapticFeedback.mediumImpact();
  }

  void gameOver() {
    if (!_storageService.getHapticEnabled()) return;
    HapticFeedback.heavyImpact();
  }
}
