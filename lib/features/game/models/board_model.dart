import '../../../core/constants/app_constants.dart';
import 'cell_model.dart';

class BoardModel {
  BoardModel() : grid = _emptyGrid();

  final List<List<CellModel>> grid;

  static List<List<CellModel>> _emptyGrid() {
    return List.generate(
      AppConstants.boardSize,
      (row) => List.generate(
        AppConstants.boardSize,
        (col) => CellModel(row: row, col: col),
      ),
    );
  }

  bool get isEmpty => grid.every((row) => row.every((cell) => !cell.occupied));

  void reset() {
    for (final row in grid) {
      for (final cell in row) {
        if (cell.isObstacle) continue;
        cell.occupied = false;
        cell.blockColor = null;
      }
    }
  }

  /// Marks [cells] as permanent obstacles: occupied, uncolored, and never
  /// cleared or reset for the remainder of the level.
  void setObstacles(List<(int, int)> cells) {
    for (final (row, col) in cells) {
      final cell = grid[row][col];
      cell.occupied = true;
      cell.blockColor = null;
      cell.isObstacle = true;
    }
  }
}
