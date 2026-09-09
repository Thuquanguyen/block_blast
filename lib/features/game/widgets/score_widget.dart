import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/game_controller.dart';

class ScoreWidget extends GetView<GameController> {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surfaceTint],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ScoreColumn(
              label: 'score_label'.tr,
              icon: Icons.bolt_rounded,
              iconColor: AppColors.primary,
              value: controller.score.value,
              alignEnd: false,
            ),
            _ScoreColumn(
              label: 'best_label'.tr,
              icon: Icons.emoji_events_rounded,
              iconColor: AppColors.accentDark,
              value: controller.bestScore.value,
              alignEnd: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Label + value column. The value pops (brief scale bounce) and counts up
/// from its previous value whenever it changes, instead of snapping instantly.
class _ScoreColumn extends StatefulWidget {
  const _ScoreColumn({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.alignEnd,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final int value;
  final bool alignEnd;

  @override
  State<_ScoreColumn> createState() => _ScoreColumnState();
}

class _ScoreColumnState extends State<_ScoreColumn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(covariant _ScoreColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _previousValue = oldWidget.value;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: widget.alignEnd
          ? [
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(widget.icon, size: 14, color: widget.iconColor),
            ]
          : [
              Icon(widget.icon, size: 14, color: widget.iconColor),
              const SizedBox(width: 4),
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
    );

    return Column(
      crossAxisAlignment: widget.alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        labelRow,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = Curves.easeOut.transform(_controller.value);
            final animatedValue =
                (_previousValue + (widget.value - _previousValue) * t).round();
            final pop = 1.0 + sin(t * pi) * 0.14;
            return Transform.scale(
              scale: pop,
              alignment: widget.alignEnd
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                '$animatedValue',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
