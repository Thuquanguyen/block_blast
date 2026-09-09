import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'remote_config_service.dart';

/// Ad loading/showing wrapper using Google's official TEST ad unit IDs.
/// Real ad unit IDs and AndroidManifest/Info.plist AdMob app-id setup are
/// left for a future pass — until then [initialize] failing must not crash
/// the app.
class AdService {
  AdService(this._remoteConfigService);

  final RemoteConfigService _remoteConfigService;

  static const _androidBannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  static const _iosBannerTestId = 'ca-app-pub-3940256099942544/2934735716';
  static const _androidInterstitialTestId =
      'ca-app-pub-3940256099942544/1033173712';
  static const _iosInterstitialTestId =
      'ca-app-pub-3940256099942544/4411468910';
  static const _androidRewardedTestId =
      'ca-app-pub-3940256099942544/5224354917';
  static const _iosRewardedTestId = 'ca-app-pub-3940256099942544/1712485313';

  String get _bannerAdUnitId =>
      Platform.isAndroid ? _androidBannerTestId : _iosBannerTestId;

  String get _interstitialAdUnitId =>
      Platform.isAndroid ? _androidInterstitialTestId : _iosInterstitialTestId;

  String get _rewardedAdUnitId =>
      Platform.isAndroid ? _androidRewardedTestId : _iosRewardedTestId;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  /// Must be called defensively: without AdMob app-id setup in
  /// AndroidManifest.xml / Info.plist this can throw, and that must not
  /// crash the app.
  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      debugPrint(
        'AdService: initialize failed ($e) — ads disabled until platform setup is done.',
      );
    }
  }

  void loadBanner({VoidCallback? onLoaded, VoidCallback? onFailed}) {
    if (_remoteConfigService.isLimit) {
      debugPrint('AdService: loadBanner skipped (isLimit remote flag is true)');
      return;
    }
    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded?.call(),
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdService: banner failed to load ($error)');
          ad.dispose();
          _bannerAd = null;
          onFailed?.call();
        },
      ),
    )..load();
  }

  BannerAd? get bannerAd => _bannerAd;

  void showBanner() {
    // Banner visibility is controlled by whether the caller places
    // [bannerAd] in the widget tree; nothing to do here beyond loading.
  }

  void hideBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  void loadInterstitial() {
    if (_remoteConfigService.isLimit) {
      debugPrint(
        'AdService: loadInterstitial skipped (isLimit remote flag is true)',
      );
      return;
    }
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) =>
            debugPrint('AdService: interstitial failed to load ($error)'),
      ),
    );
  }

  void showInterstitial() {
    final ad = _interstitialAd;
    if (ad == null) return;
    ad.show();
    _interstitialAd = null;
  }

  void loadRewarded() {
    if (_remoteConfigService.isLimit) {
      debugPrint(
        'AdService: loadRewarded skipped (isLimit remote flag is true)',
      );
      return;
    }
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) =>
            debugPrint('AdService: rewarded failed to load ($error)'),
      ),
    );
  }

  void showRewarded(void Function() onRewarded) {
    final ad = _rewardedAd;
    if (ad == null) return;
    ad.show(onUserEarnedReward: (_, reward) => onRewarded());
    _rewardedAd = null;
  }
}
