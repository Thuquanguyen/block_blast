import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Thin wrapper around [FirebaseRemoteConfig]. Remote Config needs
/// Firebase.initializeApp() to have already succeeded, and can fail without
/// a real Firebase project configured — [initialize] guards against that so
/// a failure here can't crash the app, same pattern as AnalyticsService.
class RemoteConfigService {
  static const _keyIsLimit = 'isLimit';
  static const _keyInReviewVersion = 'inReviewVersion';
  static const _keyRequiredVersion = 'requiredVersion';

  // Accessed lazily (not as an eager field) because Get.put(RemoteConfigService())
  // runs before Firebase.initializeApp() completes (see main.dart) — grabbing
  // FirebaseRemoteConfig.instance eagerly throws '[core/no-app]' the moment a
  // real GoogleService-Info.plist/google-services.json is present.
  FirebaseRemoteConfig get _remoteConfig => FirebaseRemoteConfig.instance;
  String _appVersion = '';

  Future<void> initialize() async {
    try {
      _appVersion = (await PackageInfo.fromPlatform()).version;
    } catch (e) {
      debugPrint('RemoteConfigService: PackageInfo.fromPlatform() failed ($e)');
    }

    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await _remoteConfig.setDefaults({
        _keyIsLimit: false,
        _keyInReviewVersion: '',
        _keyRequiredVersion: '',
      });
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint(
        'RemoteConfigService: initialize failed ($e) — using defaults.',
      );
    }
  }

  bool get isLimit => _tryGetBool(_keyIsLimit);

  String get inReviewVersion => _tryGetString(_keyInReviewVersion);

  String get requiredVersion => _tryGetString(_keyRequiredVersion);

  // Callers (e.g. AdService) may read these before initialize() has
  // finished — fall back to the same defaults setConfigSettings() would
  // have set rather than throwing.
  bool _tryGetBool(String key) {
    try {
      return _remoteConfig.getBool(key);
    } catch (e) {
      return false;
    }
  }

  String _tryGetString(String key) {
    try {
      return _remoteConfig.getString(key);
    } catch (e) {
      return '';
    }
  }

  bool get isInReviewVersion =>
      inReviewVersion.isNotEmpty && inReviewVersion == _appVersion;

  bool get isUpdateRequired {
    if (requiredVersion.isEmpty) return false;
    return _compareVersions(requiredVersion, _appVersion) > 0;
  }

  /// Compares two "major.minor.patch"-style version strings numerically.
  /// Returns > 0 if [a] is newer than [b], < 0 if older, 0 if equal.
  int _compareVersions(String a, String b) {
    final partsA = a.split('.').map((p) => int.tryParse(p) ?? 0).toList();
    final partsB = b.split('.').map((p) => int.tryParse(p) ?? 0).toList();
    final length = partsA.length > partsB.length
        ? partsA.length
        : partsB.length;
    for (var i = 0; i < length; i++) {
      final valueA = i < partsA.length ? partsA[i] : 0;
      final valueB = i < partsB.length ? partsB[i] : 0;
      if (valueA != valueB) return valueA - valueB;
    }
    return 0;
  }
}
