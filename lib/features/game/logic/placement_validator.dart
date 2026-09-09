import '../../../core/constants/app_constants.dart';
import '../models/block_model.dart';
import '../models/board_model.dart';

class PlacementValidator {
  PlacementValidator._();

  /// Whether [block] can be placed with its top-left at ([row], [col]).
  static bool canPlace(BoardModel board, BlockModel block, int row, int col) {
    for (final offset in block.cells) {
      final r = row + offset.row;
      final c = col + offset.col;
      if (r < 0 ||
          r >= AppConstants.boardSize ||
          c < 0 ||
          c >= AppConstants.boardSize) {
        return false;
      }
      if (board.grid[r][c].occupied) return false;
    }
    return true;
  }

  /// Whether [block] fits anywhere at all on the current [board].
  static bool hasValidPlacement(BoardModel board, BlockModel block) {
    return findValidPlacement(board, block) != null;
  }

  /// The first (row, col) — scanning top-to-bottom, left-to-right — where
  /// [block] fits on [board], or null if it doesn't fit anywhere.
  static (int, int)? findValidPlacement(BoardModel board, BlockModel block) {
    for (var row = 0; row < AppConstants.boardSize; row++) {
      for (var col = 0; col < AppConstants.boardSize; col++) {
        if (canPlace(board, block, row, col)) return (row, col);
      }
    }
    return null;
  }
}
