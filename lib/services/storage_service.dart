import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around [SharedPreferences] for app-wide persisted values.
class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  static const _bestScoreKey = 'best_score';
  static const _soundEnabledKey = 'sound_enabled';
  static const _musicEnabledKey = 'music_enabled';
  static const _hapticEnabledKey = 'haptic_enabled';
  static const _removeAdsKey = 'remove_ads';
  static const _lastDailyRewardClaimKey = 'last_daily_reward_claim';
  static const _streakDayKey = 'daily_reward_streak_day';
  static const _completedJourneyLevelsKey = 'completed_journey_levels';
  static const _tutorialCompletedKey = 'tutorial_completed';
  static const _nicknameKey = 'nickname';

  int getBestScore() => _prefs.getInt(_bestScoreKey) ?? 0;

  Future<void> saveBestScore(int score) => _prefs.setInt(_bestScoreKey, score);

  bool getSoundEnabled() => _prefs.getBool(_soundEnabledKey) ?? true;

  Future<void> saveSoundEnabled(bool enabled) =>
      _prefs.setBool(_soundEnabledKey, enabled);

  bool getMusicEnabled() => _prefs.getBool(_musicEnabledKey) ?? true;

  Future<void> saveMusicEnabled(bool enabled) =>
      _prefs.setBool(_musicEnabledKey, enabled);

  bool getHapticEnabled() => _prefs.getBool(_hapticEnabledKey) ?? true;

  Future<void> saveHapticEnabled(bool enabled) =>
      _prefs.setBool(_hapticEnabledKey, enabled);

  bool getRemoveAds() => _prefs.getBool(_removeAdsKey) ?? false;

  Future<void> saveRemoveAds(bool removeAds) =>
      _prefs.setBool(_removeAdsKey, removeAds);

  /// Date string (yyyy-MM-dd) of the last claimed daily reward, or null if
  /// none has been claimed yet.
  String? getLastDailyRewardClaimDate() =>
      _prefs.getString(_lastDailyRewardClaimKey);

  Future<void> saveLastDailyRewardClaimDate(String date) =>
      _prefs.setString(_lastDailyRewardClaimKey, date);

  /// Current day (1-7) of the daily-reward streak cycle, 0 if never claimed.
  int getStreakDay() => _prefs.getInt(_streakDayKey) ?? 0;

  Future<void> saveStreakDay(int day) => _prefs.setInt(_streakDayKey, day);

  /// Journey level numbers the player has already cleared.
  Set<int> getCompletedJourneyLevels() =>
      (_prefs.getStringList(_completedJourneyLevelsKey) ?? [])
          .map(int.parse)
          .toSet();

  Future<void> saveCompletedJourneyLevels(Set<int> levels) =>
      _prefs.setStringList(
        _completedJourneyLevelsKey,
        levels.map((n) => n.toString()).toList(),
      );

  bool getTutorialCompleted() => _prefs.getBool(_tutorialCompletedKey) ?? false;

  Future<void> saveTutorialCompleted(bool completed) =>
      _prefs.setBool(_tutorialCompletedKey, completed);

  String getNickname() => _prefs.getString(_nicknameKey) ?? '';

  Future<void> saveNickname(String nickname) =>
      _prefs.setString(_nicknameKey, nickname);
}
