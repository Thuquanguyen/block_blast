import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'services/ad_service.dart';
import 'services/analytics_service.dart';
import 'services/audio_service.dart';
import 'services/haptic_service.dart';
import 'services/iap_service.dart';
import 'services/leaderboard_service.dart';
import 'services/remote_config_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = Get.put(await StorageService.init());
  Get.put(HapticService(storageService));
  Get.put(AudioService(storageService));
  Get.put(IapService(storageService));
  Get.put(AnalyticsService());
  Get.put(RemoteConfigService());
  Get.put(LeaderboardService());
  Get.put(AdService(Get.find<RemoteConfigService>()));

  runApp(const MyApp());

  // These call out to third-party SDKs (network, native init) — run them
  // after the first frame so a slow/unreachable SDK can't block app launch.
  // No firebase_options.dart exists yet since there's no real Firebase
  // project configured — TODO: run `flutterfire configure` once one exists,
  // then pass DefaultFirebaseOptions.currentPlatform below.
  try {
    await Firebase.initializeApp();
    Get.find<AnalyticsService>().appOpen();
    await Get.find<RemoteConfigService>().initialize();
  } catch (e) {
    debugPrint(
      'Firebase.initializeApp() failed ($e) — analytics/remote config will no-op.',
    );
  }

  // AdMob app-id setup in AndroidManifest.xml / Info.plist isn't done yet;
  // initialize() guards against that so a failure here can't crash the app.
  final adService = Get.find<AdService>();
  await adService.initialize();
  // Preload an interstitial at launch so the first cooldown-eligible game
  // over already has one ready, instead of showing nothing the first time.
  adService.loadInterstitial();
}
