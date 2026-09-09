import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../../services/analytics_service.dart';
import '../../../services/storage_service.dart';

/// A single level in journey mode: its number and the score the player must
/// reach to clear it.
class JourneyLevel {
  const JourneyLevel(
    this.number,
    this.targetScore, {
    this.obstacleCells = const [],
  });

  final int number;
  final int targetScore;

  /// Permanent pre-occupied (row, col) cells for this level's board, in
  /// escalating count/complexity as level number increases.
  final List<(int, int)> obstacleCells;
}

class JourneyController extends GetxController {
  JourneyController(this._analyticsService, this._storageService);

  final AnalyticsService _analyticsService;
  final StorageService _storageService;

  /// Levels the player has already reached the target score for.
  final RxSet<int> completedLevels = <int>{}.obs;

  /// Static level list per the spec: L1-L5 fixed, then a gentle increasing
  /// curve for the rest.
  static final List<JourneyLevel> levels = [
    const JourneyLevel(1, 500),
    const JourneyLevel(2, 1000),
    const JourneyLevel(3, 1500),
    const JourneyLevel(4, 2500),
    const JourneyLevel(5, 3500),
    // L6-10: 1-2 single obstacles scattered near the center.
    JourneyLevel(6, 3500 + 750, obstacleCells: const [(4, 4)]),
    JourneyLevel(7, 3500 + 2 * 750, obstacleCells: const [(4, 5), (5, 4)]),
    JourneyLevel(8, 3500 + 3 * 750, obstacleCells: const [(3, 3)]),
    JourneyLevel(9, 3500 + 4 * 750, obstacleCells: const [(3, 6), (6, 3)]),
    JourneyLevel(10, 3500 + 5 * 750, obstacleCells: const [(4, 4), (5, 5)]),
    // L11-15: 3-5 obstacles.
    JourneyLevel(
      11,
      3500 + 6 * 750,
      obstacleCells: const [(3, 3), (3, 6), (6, 3)],
    ),
    JourneyLevel(
      12,
      3500 + 7 * 750,
      obstacleCells: const [(4, 4), (4, 5), (5, 4), (5, 5)],
    ),
    JourneyLevel(
      13,
      3500 + 8 * 750,
      obstacleCells: const [(2, 5), (5, 2), (5, 7), (7, 5)],
    ),
    JourneyLevel(
      14,
      3500 + 9 * 750,
      obstacleCells: const [(3, 3), (3, 4), (6, 5), (6, 6), (4, 7)],
    ),
    JourneyLevel(
      15,
      3500 + 10 * 750,
      obstacleCells: const [(2, 2), (2, 7), (7, 2), (7, 7), (4, 4)],
    ),
    // L16-20: 6-10 obstacles arranged in clusters/patterns.
    JourneyLevel(
      16,
      3500 + 11 * 750,
      obstacleCells: const [
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5),
        (6, 6),
        (7, 7),
      ],
    ),
    JourneyLevel(
      17,
      3500 + 12 * 750,
      obstacleCells: const [
        (9, 2),
        (9, 3),
        (9, 4),
        (9, 5),
        (9, 6),
        (9, 7),
        (9, 8),
      ],
    ),
    JourneyLevel(
      18,
      3500 + 13 * 750,
      obstacleCells: const [
        (2, 2),
        (2, 3),
        (3, 2),
        (3, 3),
        (6, 6),
        (6, 7),
        (7, 6),
        (7, 7),
      ],
    ),
    JourneyLevel(
      19,
      3500 + 14 * 750,
      obstacleCells: const [
        (2, 4),
        (3, 4),
        (4, 4),
        (5, 4),
        (6, 4),
        (4, 2),
        (4, 3),
        (4, 5),
        (4, 6),
      ],
    ),
    JourneyLevel(
      20,
      3500 + 15 * 750,
      obstacleCells: const [
        (0, 4),
        (0, 5),
        (9, 4),
        (9, 5),
        (4, 0),
        (5, 0),
        (4, 9),
        (5, 9),
        (4, 4),
        (5, 5),
      ],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    completedLevels.addAll(_storageService.getCompletedJourneyLevels());
  }

  Future<void> startLevel(JourneyLevel level) async {
    _analyticsService.journeyStarted(level.number);
    final result = await Get.toNamed(
      Routes.GAME,
      arguments: {
        'targetScore': level.targetScore,
        'obstacleCells': [
          for (final (row, col) in level.obstacleCells) [row, col],
        ],
      },
    );
    if (result == true) {
      completedLevels.add(level.number);
      await _storageService.saveCompletedJourneyLevels(completedLevels);
      _analyticsService.journeyCompleted(level.number);
    }
  }
}
