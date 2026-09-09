import '../../../core/constants/app_constants.dart';
import '../models/block_model.dart';
import '../models/board_model.dart';
import '../models/game_state.dart';
import 'placement_validator.dart';
import 'score_calculator.dart';

/// Pure game rules for the 10x10 block puzzle: placement, line clearing,
/// scoring and combo tracking. Holds no Flutter/Get dependencies.
class GameEngine {
  final BoardModel board = BoardModel();
  int combo = 0;

  bool canPlaceBlock(BlockModel block, int row, int col) {
    return PlacementValidator.canPlace(board, block, row, col);
  }

  /// Places [block] at ([row], [col]), clears completed lines, updates the
  /// combo streak and returns the resulting [PlacementResult].
  ///
  /// Caller must ensure [canPlaceBlock] is true beforehand.
  PlacementResult placeBlock(
    BlockModel block,
    int row,
    int col,
    List<BlockModel> remainingBlocks,
  ) {
    for (final offset in block.cells) {
      final cell = board.grid[row + offset.row][col + offset.col];
      cell.occupied = true;
      cell.blockColor = block.color;
    }

    final clearedCells = _clearedCells();
    final clearedCellColors = [
      for (final (row, col) in clearedCells)
        board.grid[row][col].blockColor ?? block.color,
    ];
    final linesCleared = clearLines();

    if (linesCleared > 0) {
      combo++;
    } else {
      combo = 0;
    }

    var score = ScoreCalculator.calculateScore(linesCleared, combo);
    final perfectClear = linesCleared > 0 && board.isEmpty;
    if (perfectClear) {
      score += AppConstants.perfectClearBonus;
    }

    return PlacementResult(
      linesCleared: linesCleared,
      scoreGained: score,
      combo: combo,
      perfectClear: perfectClear,
      isGameOver: isGameOver(remainingBlocks),
      clearedCells: clearedCells,
      clearedCellColors: clearedCellColors,
    );
  }

  /// Coordinates of every cell that would be cleared by [clearLines] right
  /// now, computed before the clear happens so callers can flash them.
  List<(int, int)> _clearedCells() {
    final size = AppConstants.boardSize;
    final fullRows = <int>[];
    final fullCols = <int>[];

    for (var row = 0; row < size; row++) {
      if (board.grid[row].every((cell) => cell.occupied)) fullRows.add(row);
    }
    for (var col = 0; col < size; col++) {
      if (board.grid.every((row) => row[col].occupied)) fullCols.add(col);
    }

    final cells = <(int, int)>{};
    for (final row in fullRows) {
      for (var col = 0; col < size; col++) {
        // Obstacle cells never actually clear (see clearLines), so they
        // must not flash/burst as if they were removed.
        if (board.grid[row][col].isObstacle) continue;
        cells.add((row, col));
      }
    }
    for (final col in fullCols) {
      for (var row = 0; row < size; row++) {
        if (board.grid[row][col].isObstacle) continue;
        cells.add((row, col));
      }
    }
    return cells.toList();
  }

  /// Clears all fully-occupied rows and columns simultaneously, returning
  /// the number of lines cleared.
  int clearLines() {
    final size = AppConstants.boardSize;
    final fullRows = <int>[];
    final fullCols = <int>[];

    for (var row = 0; row < size; row++) {
      if (board.grid[row].every((cell) => cell.occupied)) fullRows.add(row);
    }
    for (var col = 0; col < size; col++) {
      if (board.grid.every((row) => row[col].occupied)) fullCols.add(col);
    }

    for (final row in fullRows) {
      for (final cell in board.grid[row]) {
        if (cell.isObstacle) continue;
        cell.occupied = false;
        cell.blockColor = null;
      }
    }
    for (final col in fullCols) {
      for (final row in board.grid) {
        final cell = row[col];
        if (cell.isObstacle) continue;
        cell.occupied = false;
        cell.blockColor = null;
      }
    }

    return fullRows.length + fullCols.length;
  }

  bool isGameOver(List<BlockModel> currentBlocks) {
    return !currentBlocks.any(
      (block) => PlacementValidator.hasValidPlacement(board, block),
    );
  }

  void resetGame() {
    board.reset();
    combo = 0;
  }
}
