import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bar_icon_badge.dart';
import '../../../core/widgets/banner_ad_slot.dart';
import '../controllers/game_controller.dart';
import '../models/block_model.dart';
import '../widgets/block_tray.dart';
import '../widgets/combo_widget.dart';
import '../widgets/draggable_block.dart';
import '../widgets/game_board.dart';
import '../widgets/game_over_dialog.dart';
import '../widgets/level_complete_dialog.dart';
import '../widgets/milestone_toast.dart';
import '../widgets/score_popup_widget.dart';
import '../widgets/score_widget.dart';

/// How far above the finger the dragged block preview floats, so the block
/// stays visible instead of being hidden under the player's thumb.
const _dragLiftOffset = Offset(0, -90);

class GameView extends GetView<GameController> {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GameBody();
  }
}

class _GameBody extends StatefulWidget {
  const _GameBody();

  @override
  State<_GameBody> createState() => _GameBodyState();
}

class _GameBodyState extends State<_GameBody> {
  final GameController controller = Get.find<GameController>();
  final GlobalKey _boardKey = GlobalKey();
  final GlobalKey _stackKey = GlobalKey();
  double _cellSize = 0;

  BlockModel? _draggingBlock;
  Offset? _dragPosition;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    ever(controller.gameOver, (isOver) {
      if (isOver == true && !_dialogShown) {
        _dialogShown = true;
        Get.dialog(const GameOverDialog(), barrierDismissible: false).then((_) {
          _dialogShown = false;
        });
      }
    });
    ever(controller.levelComplete, (isComplete) {
      if (isComplete == true && !_dialogShown) {
        _dialogShown = true;
        Get.dialog(const LevelCompleteDialog(), barrierDismissible: false).then(
          (_) {
            _dialogShown = false;
          },
        );
      }
    });
  }

  void _onDragStart(BlockModel block) {
    setState(() => _draggingBlock = block);
  }

  void _onDragUpdate(BlockModel block, Offset globalPosition) {
    setState(() {
      _draggingBlock = block;
      _dragPosition = globalPosition;
    });
  }

  void _onDragEnd(BlockModel block, Offset globalPosition) {
    final cell = _cellUnderFinger(block, globalPosition);
    if (cell != null && controller.canPlaceBlockAt(block, cell.$1, cell.$2)) {
      controller.placeBlockAt(block, cell.$1, cell.$2);
    }
    setState(() {
      _draggingBlock = null;
      _dragPosition = null;
    });
  }

  (int, int)? _cellUnderFinger(BlockModel block, Offset globalPosition) {
    final renderObject = _boardKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || _cellSize <= 0) return null;

    final anchor = globalPosition + _dragLiftOffset;
    final local = renderObject.globalToLocal(anchor);
    final topLeft =
        local -
        Offset(block.colSpan * _cellSize / 2, block.rowSpan * _cellSize / 2);

    final col = (topLeft.dx / _cellSize).round();
    final row = (topLeft.dy / _cellSize).round();
    return (row, col);
  }

  Widget _buildDragPreview() {
    final stackBox = _stackKey.currentContext?.findRenderObject();
    final block = _draggingBlock!;
    var anchor = _dragPosition! + _dragLiftOffset;
    if (stackBox is RenderBox) {
      anchor = stackBox.globalToLocal(anchor);
    }
    return Positioned(
      left: anchor.dx - (block.colSpan * _cellSize / 2),
      top: anchor.dy - (block.rowSpan * _cellSize / 2),
      child: IgnorePointer(
        child: BlockPreview(block: block, cellSize: _cellSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('game_title'.tr),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: AppBarIconBadge(
            icon: Icons.arrow_back_rounded,
            tooltip: 'game_back_tooltip'.tr,
            onPressed: Get.back,
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Stack(
            key: _stackKey,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ScoreWidget(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: ComboWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _BoosterButton(
                          icon: Icons.lightbulb_rounded,
                          countListenable: controller.hintsRemaining,
                          onPressed: controller.useHint,
                          enabled: () =>
                              controller.hintsRemaining.value > 0 &&
                              !controller.gameOver.value,
                        ),
                        const SizedBox(width: 12),
                        _BoosterButton(
                          icon: Icons.undo_rounded,
                          countListenable: controller.undosRemaining,
                          onPressed: controller.undoLastMove,
                          enabled: () => controller.canUndo,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          _cellSize = constraints.maxWidth / 10;
                          return GameBoard(boardKey: _boardKey);
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: BlockTray(
                        trayCellSize: 22,
                        onDragStart: _onDragStart,
                        onDragUpdate: _onDragUpdate,
                        onDragEnd: _onDragEnd,
                        onTap: controller.rotateBlock,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: BannerAdSlot(),
                  ),
                ],
              ),
              if (_draggingBlock != null && _dragPosition != null)
                _buildDragPreview(),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Center(
                    child: Obx(
                      () => Column(
                        children: [
                          for (final popup in controller.scorePopups)
                            ScorePopupWidget(
                              key: ValueKey(popup.id),
                              amount: popup.amount,
                              onComplete: () =>
                                  controller.removeScorePopup(popup.id),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 140,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Center(
                    child: Obx(
                      () => Column(
                        children: [
                          for (final toast in controller.milestoneToasts)
                            MilestoneToastWidget(
                              key: ValueKey(toast.id),
                              threshold: toast.threshold,
                              onComplete: () =>
                                  controller.removeMilestoneToast(toast.id),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A compact circular icon button with a small count badge, used for the
/// hint/undo boosters. Dims and disables when [enabled] returns false.
class _BoosterButton extends StatelessWidget {
  const _BoosterButton({
    required this.icon,
    required this.countListenable,
    required this.onPressed,
    required this.enabled,
  });

  final IconData icon;
  final RxInt countListenable;
  final VoidCallback onPressed;
  final bool Function() enabled;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = countListenable.value;
      final isEnabled = enabled();
      return Opacity(
        opacity: isEnabled ? 1.0 : 0.4,
        child: GestureDetector(
          onTap: isEnabled ? onPressed : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: AppColors.primaryDark, size: 20),
              ),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
