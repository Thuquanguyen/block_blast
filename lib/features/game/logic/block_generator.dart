import 'dart:math';

import '../../../core/constants/app_constants.dart';
import '../models/block_model.dart';
import '../models/board_model.dart';
import 'placement_validator.dart';

class BlockGenerator {
  BlockGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;
  int _nextId = 0;

  BlockModel _randomBlock() {
    final shape = BlockModel
        .shapeCatalogue[_random.nextInt(BlockModel.shapeCatalogue.length)];
    final color = AppConstants
        .blockColors[_random.nextInt(AppConstants.blockColors.length)];
    return BlockModel(id: 'block_${_nextId++}', shape: shape, color: color);
  }

  /// Generates a batch of [AppConstants.blocksPerBatch] blocks, retrying the
  /// whole batch until at least one block is placeable on [board].
  List<BlockModel> generateBatch(BoardModel board) {
    for (
      var attempt = 0;
      attempt < AppConstants.maxBatchGenerationRetries;
      attempt++
    ) {
      final batch = List.generate(
        AppConstants.blocksPerBatch,
        (_) => _randomBlock(),
      );
      if (batch.any(
        (block) => PlacementValidator.hasValidPlacement(board, block),
      )) {
        return batch;
      }
    }
    // Fallback: accept whatever the last attempt produced rather than looping forever.
    return List.generate(AppConstants.blocksPerBatch, (_) => _randomBlock());
  }
}
