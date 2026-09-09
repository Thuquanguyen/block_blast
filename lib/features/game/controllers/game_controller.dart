import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../services/ad_service.dart';
import '../../../services/analytics_service.dart';
import '../../../services/haptic_service.dart';
import '../../../services/leaderboard_service.dart';
import '../../../services/storage_service.dart';
import '../logic/block_generator.dart';
import '../logic/game_engine.dart';
import '../logic/placement_validator.dart';
import '../models/block_model.dart';
import '../models/cell_model.dart';

/// Minimum time between two interstitial shows, so a player who restarts
/// quickly isn't hit with an ad every time.
const _interstitialCooldown = Duration(seconds: 90);

/// Show an interstitial once every this-many completed games (not revives).
const _gamesPerInterstitial = 3;

/// A transient "+250" popup shown near where a line was cleared.
class ScorePopup {
  ScorePopup(this.amount) : id = _nextId++;

  static int _nextId = 0;

  final int id;
  final int amount;
}

/// A line-clear particle burst request: the cleared cell coordinates and the
/// color each cell was, for [ClearBurstOverlay] to animate.
class ClearBurst {
  ClearBurst(this.cells, this.colors) : id = _nextId++;

  static int _nextId = 0;

  final int id;
  final List<(int, int)> cells;
  final List<Color> colors;
}

/// A "you just crossed a score milestone" toast request, mirroring
/// [ScorePopup]'s id/list/remove-by-id shape.
class MilestoneToast {
  MilestoneToast(this.threshold) : id = _nextId++;

  static int _nextId = 0;

  final int id;
  final int threshold;
}

class GameController extends GetxController {
  GameController(
    this._storageService,
    this._hapticService,
    this._analyticsService,
    this._adService,
    this._leaderboardService,
  );

  final StorageService _storageService;
  final HapticService _hapticService;
  final AnalyticsService _analyticsService;
  final AdService _adService;
  final LeaderboardService _leaderboardService;
  final GameEngine _engine = GameEngine();
  final BlockGenerator _blockGenerator = BlockGenerator();

  final score = 0.obs;
  final bestScore = 0.obs;
  final combo = 0.obs;
  final gameOver = false.obs;
  final levelComplete = false.obs;
  final reviveUsed = false.obs;
  final currentBlocks = <BlockModel>[].obs;
  final flashingCells = <(int, int)>{}.obs;
  final scorePopups = <ScorePopup>[].obs;
  final clearBursts = <ClearBurst>[].obs;
  final perfectClearFlash = false.obs;
  final milestoneToasts = <MilestoneToast>[].obs;
  late final RxList<List<CellModel>> board;

  /// Set from route arguments in journey mode; null means classic endless.
  int? targetScore;

  /// Set from route arguments in journey mode; empty means no obstacles
  /// (classic endless, or journey levels 1-5).
  List<(int, int)> _obstacleCells = const [];

  final hintsRemaining = AppConstants.hintsPerGame.obs;
  final activeHint = Rx<({String blockId, int row, int col})?>(null);
  Timer? _hintTimer;

  final undosRemaining = AppConstants.undosPerGame.obs;

  Timer? _flashTimer;
  int _blocksPlaced = 0;
  int _linesCleared = 0;
  final Set<int> _milestonesShown = {};

  /// Snapshot of the board+blocks (and the score/combo state right before
  /// that placement) taken right before a game-over check fires, so
  /// [revive] can restore the board and [undoLastMove] can fully revert
  /// both the board and that move's score/combo/win effects.
  List<List<CellModel>>? _reviveSnapshotBoard;
  List<BlockModel>? _reviveSnapshotBlocks;
  int? _reviveSnapshotScore;
  int? _reviveSnapshotCombo;
  int? _reviveSnapshotBestScore;
  Set<int>? _reviveSnapshotMilestonesShown;

  int _gamesPlayedSinceInterstitial = 0;
  DateTime? _lastInterstitialShownAt;

  /// True only when there's a snapshot to restore, undo uses remain, and
  /// the game isn't already over (that's what revive/rewarded-ad handles).
  bool get canUndo =>
      _reviveSnapshotBoard != null &&
      undosRemaining.value > 0 &&
      !gameOver.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['targetScore'] is int) {
      targetScore = args['targetScore'] as int;
    }
    if (args is Map && args['obstacleCells'] is List) {
      _obstacleCells = [
        for (final cell in args['obstacleCells'] as List)
          (cell[0] as int, cell[1] as int),
      ];
    }
    board = _engine.board.grid.obs;
    bestScore.value = _storageService.getBestScore();
    startNewGame();
  }

  void startNewGame() {
    _engine.resetGame();
    _engine.board.setObstacles(_obstacleCells);
    score.value = 0;
    combo.value = 0;
    gameOver.value = false;
    levelComplete.value = false;
    reviveUsed.value = false;
    _blocksPlaced = 0;
    _linesCleared = 0;
    _flashTimer?.cancel();
    flashingCells.clear();
    scorePopups.clear();
    clearBursts.clear();
    perfectClearFlash.value = false;
    milestoneToasts.clear();
    _milestonesShown.clear();
    _hintTimer?.cancel();
    activeHint.value = null;
    hintsRemaining.value = AppConstants.hintsPerGame;
    undosRemaining.value = AppConstants.undosPerGame;
    // Defensive: a rewarded-ad callback abandoned from a previous game
    // (e.g. the user backs out before it completes) must not be able to
    // revive() into this fresh game using a stale snapshot.
    _reviveSnapshotBoard = null;
    _reviveSnapshotBlocks = null;
    _reviveSnapshotScore = null;
    _reviveSnapshotCombo = null;
    _reviveSnapshotBestScore = null;
    _reviveSnapshotMilestonesShown = null;
    currentBlocks.value = _blockGenerator.generateBatch(_engine.board);
    board.refresh();
    _analyticsService.gameStarted();
    _adService.loadRewarded();
  }

  /// Called from the game-over dialog's "New Game" action: counts the
  /// completed game and, on every third one (with a cooldown), shows an
  /// interstitial before starting the next game.
  void startNewGameAfterGameOver() {
    _gamesPlayedSinceInterstitial++;
    final now = DateTime.now();
    final cooldownElapsed =
        _lastInterstitialShownAt == null ||
        now.difference(_lastInterstitialShownAt!) >= _interstitialCooldown;
    if (_gamesPlayedSinceInterstitial >= _gamesPerInterstitial &&
        cooldownElapsed) {
      _gamesPlayedSinceInterstitial = 0;
      _lastInterstitialShownAt = now;
      _adService.showInterstitial();
      _adService.loadInterstitial();
    }
    startNewGame();
  }

  /// Restores the board+blocks to the state captured just before the last
  /// game-over check, per the one-revive-per-game rule.
  void revive() {
    if (reviveUsed.value ||
        _reviveSnapshotBoard == null ||
        _reviveSnapshotBlocks == null)
      return;
    reviveUsed.value = true;
    _engine.board.grid
      ..clear()
      ..addAll(_reviveSnapshotBoard!);
    currentBlocks.value = List.of(_reviveSnapshotBlocks!);
    gameOver.value = false;
    board.value = _engine.board.grid;
    board.refresh();
    _analyticsService.reviveUsed();
  }

  bool canPlaceBlockAt(BlockModel block, int row, int col) {
    return _engine.canPlaceBlock(block, row, col);
  }

  void placeBlockAt(BlockModel block, int row, int col) {
    if (gameOver.value || !_engine.canPlaceBlock(block, row, col)) return;

    // Snapshot the board+blocks (and score/combo state) as they were just
    // before this placement — i.e. the last known-playable state — so a
    // revive after a game-ending move restores somewhere the player can
    // actually still move, and so undoLastMove can fully revert this move's
    // score/combo/win effects, not just the board.
    _reviveSnapshotBoard = _engine.board.grid
        .map((row) => row.map((c) => c.copyWith()).toList())
        .toList();
    _reviveSnapshotBlocks = List.of(currentBlocks);
    _reviveSnapshotScore = score.value;
    _reviveSnapshotCombo = combo.value;
    _reviveSnapshotBestScore = bestScore.value;
    _reviveSnapshotMilestonesShown = Set.of(_milestonesShown);

    // Any pending hint is for the pre-placement board and is no longer valid.
    _clearHint();

    final remainingBlocks = currentBlocks
        .where((b) => b.id != block.id)
        .toList();
    final result = _engine.placeBlock(block, row, col, remainingBlocks);

    _hapticService.placeBlock();
    _blocksPlaced++;

    score.value += result.scoreGained;
    combo.value = result.combo;
    board.refresh();
    _checkMilestones();

    if (result.linesCleared > 0) {
      _linesCleared += result.linesCleared;
      _hapticService.lineClearOrCombo();
      _flashClearedCells(result.clearedCells);
      clearBursts.add(
        ClearBurst(result.clearedCells, result.clearedCellColors),
      );
      scorePopups.add(ScorePopup(result.scoreGained));
      _analyticsService.lineCleared(result.linesCleared);
      if (result.combo > 1) {
        _analyticsService.comboCreated(result.combo);
      }
      if (result.perfectClear) {
        _analyticsService.perfectClear();
        _flashPerfectClear();
      }
    }

    currentBlocks.remove(block);
    if (currentBlocks.isEmpty) {
      currentBlocks.value = _blockGenerator.generateBatch(_engine.board);
    }

    final target = targetScore;
    if (target != null && score.value >= target) {
      _winLevel();
      return;
    }

    final isOver = _engine.isGameOver(currentBlocks);
    if (isOver) {
      _endGame();
    }
  }

  /// Rotates [block] 90° clockwise in place within the tray, preserving its
  /// list index (no reshuffle, no new batch generation).
  void rotateBlock(BlockModel block) {
    final index = currentBlocks.indexWhere((b) => b.id == block.id);
    if (index == -1) return;
    currentBlocks[index] = block.rotated();
    _hapticService.rotateBlock();
    // The active hint's cells were only validated for this block's
    // pre-rotation shape — rotating it can point the glow at an unvalidated
    // (possibly invalid) placement, so clear it rather than show it stale.
    if (activeHint.value?.blockId == block.id) {
      _clearHint();
    }
  }

  /// Finds a valid placement for the first (in tray order) placeable block
  /// and briefly highlights it on the board. No-ops if out of hints, the
  /// game is over, or no block currently has a valid placement.
  // TODO: gate on a rewarded ad / IAP once hint monetization is designed.
  void useHint() {
    if (hintsRemaining.value <= 0 || gameOver.value) return;
    for (final block in currentBlocks) {
      final placement = PlacementValidator.findValidPlacement(
        _engine.board,
        block,
      );
      if (placement != null) {
        hintsRemaining.value--;
        activeHint.value = (
          blockId: block.id,
          row: placement.$1,
          col: placement.$2,
        );
        _hintTimer?.cancel();
        _hintTimer = Timer(const Duration(seconds: 3), _clearHint);
        _analyticsService.hintUsed();
        return;
      }
    }
  }

  void _clearHint() {
    _hintTimer?.cancel();
    activeHint.value = null;
  }

  /// Restores the board, tray, score, combo and win state to what they were
  /// right before the last placement, per the one-undo-per-game rule.
  // TODO: gate on a rewarded ad / IAP once undo monetization is designed.
  void undoLastMove() {
    if (!canUndo) return;
    _engine.board.grid
      ..clear()
      ..addAll(_reviveSnapshotBoard!);
    currentBlocks.value = List.of(_reviveSnapshotBlocks!);
    score.value = _reviveSnapshotScore!;
    combo.value = _reviveSnapshotCombo!;
    bestScore.value = _reviveSnapshotBestScore!;
    _storageService.saveBestScore(_reviveSnapshotBestScore!);
    _milestonesShown
      ..clear()
      ..addAll(_reviveSnapshotMilestonesShown!);
    levelComplete.value = false;
    undosRemaining.value--;
    board.value = _engine.board.grid;
    board.refresh();
    _clearHint();

    _reviveSnapshotBoard = null;
    _reviveSnapshotBlocks = null;
    _reviveSnapshotScore = null;
    _reviveSnapshotCombo = null;
    _reviveSnapshotBestScore = null;
    _reviveSnapshotMilestonesShown = null;

    _analyticsService.undoUsed();
  }

  void removeScorePopup(int id) {
    scorePopups.removeWhere((p) => p.id == id);
  }

  void removeClearBurst(int id) {
    clearBursts.removeWhere((b) => b.id == id);
  }

  void removeMilestoneToast(int id) {
    milestoneToasts.removeWhere((t) => t.id == id);
  }

  void _checkMilestones() {
    for (final threshold in AppConstants.scoreMilestones) {
      if (score.value >= threshold && _milestonesShown.add(threshold)) {
        milestoneToasts.add(MilestoneToast(threshold));
        _analyticsService.milestoneReached(threshold);
      }
    }
  }

  void _flashClearedCells(List<(int, int)> cells) {
    flashingCells.addAll(cells);
    _flashTimer?.cancel();
    _flashTimer = Timer(const Duration(milliseconds: 200), () {
      flashingCells.clear();
    });
  }

  void _flashPerfectClear() {
    perfectClearFlash.value = true;
  }

  void clearPerfectClearFlash() {
    perfectClearFlash.value = false;
  }

  void _winLevel() {
    levelComplete.value = true;
    if (score.value > bestScore.value) {
      bestScore.value = score.value;
      _storageService.saveBestScore(score.value);
    }
  }

  void _endGame() {
    gameOver.value = true;
    _hapticService.gameOver();
    if (score.value > bestScore.value) {
      bestScore.value = score.value;
      _storageService.saveBestScore(score.value);
      // Fire-and-forget: a failed submission (no Firestore enabled yet,
      // offline, etc.) must be silent, same as other third-party services.
      _leaderboardService
          .ensureSignedIn()
          .then((uid) {
            final storedNickname = _storageService.getNickname();
            final nickname = storedNickname.isNotEmpty
                ? storedNickname
                : 'Player${(uid ?? '').padRight(4, '0').substring(0, 4)}';
            _leaderboardService.submitScore(
              score: score.value,
              nickname: nickname,
            );
          });
    }
    _analyticsService.gameOver(
      score: score.value,
      bestScore: bestScore.value,
      durationSeconds: 0,
      blocksPlaced: _blocksPlaced,
      linesCleared: _linesCleared,
    );
    if (!reviveUsed.value) {
      _analyticsService.reviveOffered();
    }
  }

  @override
  void onClose() {
    _flashTimer?.cancel();
    _hintTimer?.cancel();
    super.onClose();
  }
}
