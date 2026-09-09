import 'package:flutter/material.dart';

/// An offset (row, col) of an occupied cell within a block's shape grid.
class BlockCellOffset {
  const BlockCellOffset(this.row, this.col);

  final int row;
  final int col;
}

class BlockModel {
  BlockModel({required this.id, required this.shape, required this.color})
    : cells = _cellsFromShape(shape);

  final String id;
  final List<List<int>> shape;
  final Color color;

  /// Occupied offsets derived from [shape], relative to the shape's top-left.
  final List<BlockCellOffset> cells;

  static List<BlockCellOffset> _cellsFromShape(List<List<int>> shape) {
    final result = <BlockCellOffset>[];
    for (var r = 0; r < shape.length; r++) {
      for (var c = 0; c < shape[r].length; c++) {
        if (shape[r][c] == 1) result.add(BlockCellOffset(r, c));
      }
    }
    return result;
  }

  int get rowSpan => shape.length;
  int get colSpan => shape.isEmpty ? 0 : shape[0].length;

  /// Returns a new [BlockModel] with [shape] rotated 90° clockwise.
  /// For an R×C shape, the rotated C×R shape has newShape[c][R-1-r] = shape[r][c].
  BlockModel rotated() {
    final rowCount = shape.length;
    final colCount = shape.isEmpty ? 0 : shape[0].length;
    final newShape = List.generate(
      colCount,
      (_) => List.filled(rowCount, 0),
    );
    for (var r = 0; r < rowCount; r++) {
      for (var c = 0; c < colCount; c++) {
        newShape[c][rowCount - 1 - r] = shape[r][c];
      }
    }
    return BlockModel(id: id, shape: newShape, color: color);
  }

  /// Fixed-orientation shape catalogue. No rotation system in this MVP;
  /// horizontal/vertical variants of directional pieces are listed separately.
  static final List<List<List<int>>> shapeCatalogue = [
    // Single
    [
      [1],
    ],
    // I2 horizontal / vertical
    [
      [1, 1],
    ],
    [
      [1],
      [1],
    ],
    // I3
    [
      [1, 1, 1],
    ],
    [
      [1],
      [1],
      [1],
    ],
    // I4
    [
      [1, 1, 1, 1],
    ],
    [
      [1],
      [1],
      [1],
      [1],
    ],
    // I5
    [
      [1, 1, 1, 1, 1],
    ],
    [
      [1],
      [1],
      [1],
      [1],
      [1],
    ],
    // O (2x2)
    [
      [1, 1],
      [1, 1],
    ],
    // L3 (corner, 3 cells)
    [
      [1, 0],
      [1, 1],
    ],
    // L4 horizontal / vertical
    [
      [1, 0, 0],
      [1, 1, 1],
    ],
    [
      [1, 1],
      [1, 0],
      [1, 0],
    ],
    // J3 (mirrored corner)
    [
      [0, 1],
      [1, 1],
    ],
    // J4 horizontal / vertical
    [
      [0, 0, 1],
      [1, 1, 1],
    ],
    [
      [1, 0],
      [1, 0],
      [1, 1],
    ],
    // T
    [
      [1, 1, 1],
      [0, 1, 0],
    ],
    [
      [0, 1],
      [1, 1],
      [0, 1],
    ],
    // S
    [
      [0, 1, 1],
      [1, 1, 0],
    ],
    [
      [1, 0],
      [1, 1],
      [0, 1],
    ],
    // Z
    [
      [1, 1, 0],
      [0, 1, 1],
    ],
    [
      [0, 1],
      [1, 1],
      [1, 0],
    ],
    // 3x3 full square
    [
      [1, 1, 1],
      [1, 1, 1],
      [1, 1, 1],
    ],
  ];
}
