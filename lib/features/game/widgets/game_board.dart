import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../controllers/game_controller.dart';
import '../models/block_model.dart';
import 'clear_burst_overlay.dart';
import 'perfect_clear_overlay.dart';

/// Paints the 10x10 board grid + occupied cells. CustomPainter is used
/// instead of 100 individual widgets for performance.
class GameBoardPainter extends CustomPainter {
  GameBoardPainter(
    this.board,
    this.flashingCells, {
    this.hintCells = const {},
    this.hintPulse = 0,
  });

  final List<List> board;

  /// Cells cleared by the last placement, briefly flashed white before the
  /// board rebuilds without them.
  final Set<(int, int)> flashingCells;

  /// Cells of the currently active hint's suggested placement, drawn with a
  /// soft pulsing glow outline distinct from [flashingCells].
  final Set<(int, int)> hintCells;

  /// 0..1 animation phase driving the hint glow's pulsing opacity/spread.
  final double hintPulse;

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / AppConstants.boardSize;
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final emptyCellPaint = Paint()..color = Colors.grey.shade100;

    for (var row = 0; row < AppConstants.boardSize; row++) {
      for (var col = 0; col < AppConstants.boardSize; col++) {
        final rect = Rect.fromLTWH(
          col * cellSize,
          row * cellSize,
          cellSize,
          cellSize,
        );
        final cell = board[row][col];
        final isFlashing = flashingCells.contains((row, col));
        final isObstacle = cell.isObstacle as bool;
        final cellPaint = Paint()
          ..color = isFlashing
              ? Colors.white
              : isObstacle
              ? Colors.blueGrey.shade600
              : cell.occupied
              ? (cell.blockColor ?? Colors.blueGrey)
              : emptyCellPaint.color;
        final cellRadius = Radius.circular(cellSize * 0.18);
        final cellRRect = RRect.fromRectAndRadius(
          rect.deflate(1.5),
          cellRadius,
        );
        canvas.drawRRect(cellRRect, cellPaint);
        if (isObstacle && !isFlashing) {
          canvas.save();
          canvas.clipRRect(cellRRect);
          final hatchPaint = Paint()
            ..color = Colors.black.withValues(alpha: 0.2)
            ..strokeWidth = 2;
          for (
            var offset = -cellSize;
            offset < cellSize * 2;
            offset += cellSize * 0.28
          ) {
            canvas.drawLine(
              Offset(rect.left + offset, rect.top),
              Offset(rect.left + offset + cellSize, rect.bottom),
              hatchPaint,
            );
          }
          canvas.restore();
        }
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, cellRadius),
          gridPaint,
        );
      }
    }

    if (hintCells.isNotEmpty) {
      // Pulses between subtle and vivid so the hint reads as "alive"
      // without being confused with the white line-clear flash.
      final pulseOpacity = 0.4 + 0.4 * hintPulse;
      final glowPaint = Paint()
        ..color = Colors.amberAccent.withValues(alpha: pulseOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 + 2 * hintPulse
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, 3 + 3 * hintPulse);
      for (final (row, col) in hintCells) {
        final rect = Rect.fromLTWH(
          col * cellSize,
          row * cellSize,
          cellSize,
          cellSize,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect.deflate(1.5),
            Radius.circular(cellSize * 0.18),
          ),
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GameBoardPainter oldDelegate) => true;
}

class GameBoard extends StatefulWidget {
  const GameBoard({super.key, required this.boardKey});

  final GlobalKey boardKey;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
    with SingleTickerProviderStateMixin {
  final GameController controller = Get.find<GameController>();
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Set<(int, int)> _hintCells(BlockModel? block, int row, int col) {
    if (block == null) return {};
    return {
      for (final offset in block.cells) (row + offset.row, col + offset.col),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      key: widget.boardKey,
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = constraints.maxWidth / AppConstants.boardSize;
          return Stack(
            children: [
              Obx(
                // .toList()/Set.of() force an actual reactive read (indexing
                // into the RxList/RxSet) so Obx has something to subscribe
                // to — just passing the bare Rx object through as a
                // constructor arg never touches its reactive getter, which
                // trips GetX's "no observable inserted" error.
                () {
                  final hint = controller.activeHint.value;
                  final block = hint == null
                      ? null
                      : controller.currentBlocks.firstWhereOrNull(
                          (b) => b.id == hint.blockId,
                        );
                  return AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) => CustomPaint(
                      painter: GameBoardPainter(
                        controller.board.toList(),
                        Set.of(controller.flashingCells),
                        hintCells: hint == null
                            ? const {}
                            : _hintCells(block, hint.row, hint.col),
                        hintPulse: _pulseController.value,
                      ),
                      size: Size.infinite,
                    ),
                  );
                },
              ),
              Obx(
                () => Stack(
                  children: [
                    for (final burst in controller.clearBursts)
                      ClearBurstOverlay(
                        key: ValueKey(burst.id),
                        cells: burst.cells,
                        colors: burst.colors,
                        cellSize: cellSize,
                        onComplete: () => controller.removeClearBurst(burst.id),
                      ),
                  ],
                ),
              ),
              Obx(
                () => controller.perfectClearFlash.value
                    ? PerfectClearOverlay(
                        onComplete: controller.clearPerfectClearFlash,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}
