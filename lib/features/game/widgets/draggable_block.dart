import 'dart:math';

import 'package:flutter/material.dart';

import '../models/block_model.dart';

/// Renders a small grid preview of [block]'s shape, used both in the tray
/// and as the floating drag preview.
class BlockPreview extends StatelessWidget {
  const BlockPreview({super.key, required this.block, this.cellSize = 20});

  final BlockModel block;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: block.colSpan * cellSize,
      height: block.rowSpan * cellSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in block.shape)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final value in row)
                  Container(
                    // Sized so the 1px margin on each side still fits inside
                    // the cellSize-per-cell budget the SizedBox above was
                    // given — otherwise each row/column overflows by 2px.
                    width: cellSize - 2,
                    height: cellSize - 2,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: value == 1 ? block.color : Colors.transparent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Minimum touch target size for a tray block, so small (e.g. 1x1) blocks
/// still get a comfortably tappable/draggable area beyond their visual size.
const _minTouchTarget = 56.0;

/// How far the pointer must move from its down position before a press is
/// committed to a drag instead of a tap. Flutter's usual touch slop
/// (kTouchSlop) is 18px, but that's tuned for widgets with generous spacing;
/// the tray sits blocks close together and a quick, mostly-stationary tap is
/// how rotation is triggered, so a smaller threshold keeps rotate-taps
/// forgiving of tiny finger jitter while still starting real drags promptly.
const _dragSlop = 8.0;

/// Wraps a [BlockPreview] with drag handling. On drag start/update it reports
/// the finger's global position via [onDragUpdate] so the parent can render a
/// floating preview and hit-test the board; [onDragEnd] fires on release. A
/// press that stays within [_dragSlop] and completes quickly is treated as a
/// tap and reported via [onTap] instead (used to rotate the block).
class DraggableBlock extends StatefulWidget {
  const DraggableBlock({
    super.key,
    required this.block,
    required this.cellSize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
    this.entranceDelay = Duration.zero,
  });

  final BlockModel block;
  final double cellSize;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final ValueChanged<Offset> onDragEnd;
  final VoidCallback onTap;

  /// Delay before this block's entrance pop plays, used by [BlockTray] to
  /// stagger a fresh batch of 3 blocks instead of popping in together.
  final Duration entranceDelay;

  @override
  State<DraggableBlock> createState() => _DraggableBlockState();
}

class _DraggableBlockState extends State<DraggableBlock>
    with TickerProviderStateMixin {
  bool _dragging = false;
  bool _dragCommitted = false;
  Offset? _downPosition;

  // Staggered scale+fade pop when a fresh block appears in the tray.
  late final AnimationController _entranceController;
  late final Animation<double> _entranceScale;

  // Very slow, very small idle "breathing" scale pulse so the tray doesn't
  // look static — paused while this block is being dragged.
  late final AnimationController _breatheController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _entranceScale = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutBack,
    );
    Future.delayed(widget.entranceDelay, () {
      if (mounted) _entranceController.forward();
    });

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        _downPosition = event.position;
        _dragCommitted = false;
        setState(() => _dragging = true);
      },
      onPointerMove: (event) {
        if (!_dragCommitted) {
          final movedDistance = (event.position - _downPosition!).distance;
          if (movedDistance <= _dragSlop) return;
          _dragCommitted = true;
          widget.onDragStart();
        }
        widget.onDragUpdate(event.position);
      },
      onPointerUp: (event) {
        setState(() => _dragging = false);
        if (_dragCommitted) {
          widget.onDragEnd(event.position);
          return;
        }
        final movedDistance = (event.position - _downPosition!).distance;
        if (movedDistance <= _dragSlop) {
          widget.onTap();
        }
      },
      onPointerCancel: (event) {
        setState(() => _dragging = false);
        if (_dragCommitted) widget.onDragEnd(event.position);
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_entranceController, _breatheController]),
        builder: (context, child) {
          final breathe = _dragging
              ? 1.0
              : 1.0 + sin(_breatheController.value * pi) * 0.015;
          return Opacity(
            opacity: _entranceScale.value.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: _entranceScale.value * breathe,
              child: child,
            ),
          );
        },
        child: AnimatedOpacity(
          opacity: _dragging && _dragCommitted ? 0.3 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            constraints: const BoxConstraints(
              minWidth: _minTouchTarget,
              minHeight: _minTouchTarget,
            ),
            alignment: Alignment.center,
            child: BlockPreview(block: widget.block, cellSize: widget.cellSize),
          ),
        ),
      ),
    );
  }
}
