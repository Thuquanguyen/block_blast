import 'package:get/get.dart';

import '../../../services/analytics_service.dart';
import '../../../services/storage_service.dart';

class DailyRewardDay {
  const DailyRewardDay(this.day, this.label);

  final int day;
  final String label;
}

class DailyRewardController extends GetxController {
  DailyRewardController(this._storageService, this._analyticsService);

  final StorageService _storageService;
  final AnalyticsService _analyticsService;

  /// Day 1-7 rewards per the spec.
  static const List<DailyRewardDay> rewards = [
    DailyRewardDay(1, 'daily_reward_day1'),
    DailyRewardDay(2, 'daily_reward_day2'),
    DailyRewardDay(3, 'daily_reward_day3'),
    DailyRewardDay(4, 'daily_reward_day4'),
    DailyRewardDay(5, 'daily_reward_day5'),
    DailyRewardDay(6, 'daily_reward_day6'),
    DailyRewardDay(7, 'daily_reward_day7'),
  ];

  late final RxBool claimedToday;

  /// Which of the 7 cycle days (1-7) is current/next to claim.
  late final RxInt currentDay;

  @override
  void onInit() {
    super.onInit();
    final today = _today();
    final lastClaim = _storageService.getLastDailyRewardClaimDate();
    final lastStreakDay = _storageService.getStreakDay();

    if (lastClaim == today) {
      // Already claimed today: show that day, highlighted as claimed.
      claimedToday = true.obs;
      currentDay = (lastStreakDay == 0 ? 1 : lastStreakDay).obs;
    } else if (lastClaim == _yesterday()) {
      // Streak continues: next day in the cycle, wrapping 7 -> 1.
      claimedToday = false.obs;
      currentDay = (lastStreakDay % 7 + 1).obs;
    } else {
      // Missed a day (or never claimed): streak resets.
      claimedToday = false.obs;
      currentDay = 1.obs;
    }
  }

  String _today() => _formatDate(DateTime.now());

  String _yesterday() =>
      _formatDate(DateTime.now().subtract(const Duration(days: 1)));

  String _formatDate(DateTime date) => '${date.year}-${date.month}-${date.day}';

  Future<void> claim() async {
    if (claimedToday.value) return;
    await _storageService.saveLastDailyRewardClaimDate(_today());
    await _storageService.saveStreakDay(currentDay.value);
    claimedToday.value = true;
    _analyticsService.dailyRewardClaimed(currentDay.value);
  }
}
