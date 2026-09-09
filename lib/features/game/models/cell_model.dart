import 'package:flutter/material.dart';

class CellModel {
  CellModel({
    required this.row,
    required this.col,
    this.occupied = false,
    this.blockColor,
    this.isObstacle = false,
  });

  final int row;
  final int col;
  bool occupied;
  Color? blockColor;
  bool isObstacle;

  CellModel copyWith({bool? occupied, Color? blockColor, bool? isObstacle}) {
    return CellModel(
      row: row,
      col: col,
      occupied: occupied ?? this.occupied,
      blockColor: blockColor ?? this.blockColor,
      isObstacle: isObstacle ?? this.isObstacle,
    );
  }
}
