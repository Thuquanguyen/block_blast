import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around [FirebaseAnalytics]. Firebase.initializeApp() is
/// guarded in main.dart, so if no project is configured yet every call here
/// simply fails silently (Firebase Analytics SDK no-ops without a valid app).
class AnalyticsService {
  // Accessed lazily (not as an eager field) because Get.put(AnalyticsService())
  // runs before Firebase.initializeApp() completes (see main.dart) — grabbing
  // FirebaseAnalytics.instance eagerly throws '[core/no-app]' the moment a
  // real GoogleService-Info.plist/google-services.json is present.
  FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  Future<void> logEvent(String name, [Map<String, Object>? params]) async {
    try {
      await _analytics.logEvent(name: name, parameters: params);
    } catch (e) {
      debugPrint('AnalyticsService: logEvent($name) failed ($e)');
    }
  }

  Future<void> appOpen() => logEvent('app_open');

  Future<void> gameStarted() => logEvent('game_started');

  Future<void> blockPlaced() => logEvent('block_placed');

  Future<void> lineCleared(int lines) =>
      logEvent('line_cleared', {'lines': lines});

  Future<void> comboCreated(int combo) =>
      logEvent('combo_created', {'combo': combo});

  Future<void> perfectClear() => logEvent('perfect_clear');

  Future<void> gameOver({
    required int score,
    required int bestScore,
    required int durationSeconds,
    required int blocksPlaced,
    required int linesCleared,
  }) {
    return logEvent('game_over', {
      'score': score,
      'best_score': bestScore,
      'duration': durationSeconds,
      'blocks_placed': blocksPlaced,
      'lines_cleared': linesCleared,
    });
  }

  Future<void> reviveOffered() => logEvent('revive_offered');

  Future<void> reviveUsed() => logEvent('revive_used');

  Future<void> dailyRewardClaimed(int day) =>
      logEvent('daily_reward_claimed', {'day': day});

  Future<void> journeyStarted(int level) =>
      logEvent('journey_started', {'level': level});

  Future<void> journeyCompleted(int level) =>
      logEvent('journey_completed', {'level': level});

  Future<void> collectionCompleted(String setName) =>
      logEvent('collection_completed', {'set_name': setName});

  Future<void> shopOpened() => logEvent('shop_opened');

  Future<void> removeAdsClicked() => logEvent('remove_ads_clicked');

  Future<void> purchaseSuccess(String productId) =>
      logEvent('purchase_success', {'product_id': productId});

  Future<void> hintUsed() => logEvent('hint_used');

  Future<void> undoUsed() => logEvent('undo_used');

  Future<void> milestoneReached(int threshold) =>
      logEvent('milestone_reached', {'threshold': threshold});
}
