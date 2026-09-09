import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'storage_service.dart';

/// In-app-purchase wrapper. Real store product IDs don't exist yet, so
/// [purchaseRemoveAds] and [restorePurchases] are stubbed to just log —
/// wire them up to `in_app_purchase`'s InAppPurchase.instance once products
/// are configured in App Store Connect / Play Console.
class IapService {
  IapService(this._storageService) {
    removeAds = _storageService.getRemoveAds().obs;
  }

  final StorageService _storageService;
  late final RxBool removeAds;

  Future<void> purchaseRemoveAds() async {
    debugPrint(
      'IapService: purchaseRemoveAds() stub — no store product configured yet.',
    );
    removeAds.value = true;
    await _storageService.saveRemoveAds(true);
  }

  Future<void> restorePurchases() async {
    debugPrint(
      'IapService: restorePurchases() stub — no store product configured yet.',
    );
  }
}
