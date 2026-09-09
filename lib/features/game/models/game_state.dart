import 'package:flutter/material.dart';

/// Outcome of a single block placement, returned by [GameEngine.placeBlock].
class PlacementResult {
  const PlacementResult({
    required this.linesCleared,
    required this.scoreGained,
    required this.combo,
    required this.perfectClear,
    required this.isGameOver,
    this.clearedCells = const [],
    this.clearedCellColors = const [],
  });

  final int linesCleared;
  final int scoreGained;
  final int combo;
  final bool perfectClear;
  final bool isGameOver;

  /// (row, col) coordinates cleared by this placement, used to briefly
  /// flash the cells before they visually disappear.
  final List<(int, int)> clearedCells;

  /// The block color each cell in [clearedCells] had right before it was
  /// cleared, same order, used to color the particle burst.
  final List<Color> clearedCellColors;
}
