import 'package:get/get.dart';

import '../../../services/leaderboard_service.dart';
import '../models/leaderboard_entry.dart';

class LeaderboardController extends GetxController {
  LeaderboardController(this._leaderboardService);

  final LeaderboardService _leaderboardService;

  final isLoading = true.obs;
  final entries = <LeaderboardEntry>[].obs;
  final myUid = Rxn<String>();
  final myRank = Rxn<int>();
  final myScore = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    myUid.value = await _leaderboardService.ensureSignedIn();
    entries.value = await _leaderboardService.topScores();
    if (myUid.value != null) {
      final myEntry = entries.firstWhereOrNull((e) => e.uid == myUid.value);
      if (myEntry != null) {
        myScore.value = myEntry.score;
        myRank.value = await _leaderboardService.myRank(myEntry.score);
      }
    }
    isLoading.value = false;
  }
}
