import 'package:flutter/material.dart';

/// Core tunables for the 10x10 block-puzzle game.
class AppConstants {
  AppConstants._();

  static const int boardSize = 10;
  static const int blocksPerBatch = 3;
  static const int maxBatchGenerationRetries = 50;

  /// Score awarded per number of lines cleared simultaneously (1-indexed by list position).
  /// Index 0 = 1 line, index 1 = 2 lines, etc. For 5+ lines, extra lines beyond 4
  /// add [extraLineBonus] each.
  static const List<int> lineClearScores = [100, 250, 500, 800];
  static const int extraLineBonus = 300;

  /// Combo multiplier by consecutive clearing streak (1-indexed by list position).
  static const List<double> comboMultipliers = [1.0, 1.2, 1.5, 2.0, 2.5];

  static const int perfectClearBonus = 1000;

  /// Score thresholds that trigger a one-time-per-game milestone toast.
  static const List<int> scoreMilestones = [500, 1000, 2500, 5000];

  /// Per-game hint and undo booster counts.
  static const int hintsPerGame = 2;
  static const int undosPerGame = 1;

  static const List<Color> blockColors = [
    Color(0xFFE74C3C),
    Color(0xFF3498DB),
    Color(0xFF2ECC71),
    Color(0xFFF1C40F),
    Color(0xFF9B59B6),
    Color(0xFFE67E22),
    Color(0xFF1ABC9C),
  ];
}
