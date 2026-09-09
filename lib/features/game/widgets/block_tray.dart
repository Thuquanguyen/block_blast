import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_controller.dart';
import '../models/block_model.dart';
import 'draggable_block.dart';

/// Shows the 3 currently available blocks; forwards drag events for each.
class BlockTray extends GetView<GameController> {
  const BlockTray({
    super.key,
    required this.trayCellSize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
  });

  final double trayCellSize;
  final ValueChanged<BlockModel> onDragStart;
  final void Function(BlockModel block, Offset position) onDragUpdate;
  final void Function(BlockModel block, Offset position) onDragEnd;
  final ValueChanged<BlockModel> onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < controller.currentBlocks.length; i++)
            DraggableBlock(
              key: ValueKey(controller.currentBlocks[i].id),
              block: controller.currentBlocks[i],
              cellSize: trayCellSize,
              entranceDelay: Duration(milliseconds: i * 90),
              onDragStart: () => onDragStart(controller.currentBlocks[i]),
              onDragUpdate: (position) =>
                  onDragUpdate(controller.currentBlocks[i], position),
              onDragEnd: (position) =>
                  onDragEnd(controller.currentBlocks[i], position),
              onTap: () => onTap(controller.currentBlocks[i]),
            ),
        ],
      ),
    );
  }
}
