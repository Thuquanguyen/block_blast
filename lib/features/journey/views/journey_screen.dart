import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/banner_ad_slot.dart';
import '../controllers/journey_controller.dart';

class JourneyScreen extends GetView<JourneyController> {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home_journey'.tr)),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: JourneyController.levels.length,
                  itemBuilder: (context, index) {
                    final level = JourneyController.levels[index];
                    return Obx(() {
                      final isCompleted = controller.completedLevels.contains(
                        level.number,
                      );
                      return _LevelButton(
                        label: 'L${level.number}',
                        targetScore: level.targetScore,
                        isCompleted: isCompleted,
                        hasObstacles: level.obstacleCells.isNotEmpty,
                        onTap: () => controller.startLevel(level),
                      );
                    });
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: BannerAdSlot(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelButton extends StatefulWidget {
  const _LevelButton({
    required this.label,
    required this.targetScore,
    required this.isCompleted,
    required this.hasObstacles,
    required this.onTap,
  });

  final String label;
  final int targetScore;
  final bool isCompleted;
  final bool hasObstacles;
  final VoidCallback onTap;

  @override
  State<_LevelButton> createState() => _LevelButtonState();
}

class _LevelButtonState extends State<_LevelButton>
    with TickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _pressScale;

  // Springy overshoot on release, matching AppButton's bounce treatment.
  late final AnimationController _releaseController;
  late final Animation<double> _releaseScale;

  // One-shot pop+rotate for the checkmark badge when a level is completed.
  late final AnimationController _badgeController;
  late final Animation<double> _badgeScale;

  // Subtle idle glow pulse inviting a tap on locked/incomplete tiles,
  // phase-offset per tile via widget.label's hash so a grid of many tiles
  // doesn't pulse in unison.
  late final AnimationController _idleController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pressScale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));

    _releaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _releaseScale =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.04), weight: 55),
          TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.0), weight: 45),
        ]).animate(
          CurvedAnimation(parent: _releaseController, curve: Curves.easeOut),
        );

    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _badgeScale = CurvedAnimation(
      parent: _badgeController,
      curve: Curves.elasticOut,
    );
    if (widget.isCompleted) _badgeController.value = 1;

    final phaseOffset = widget.label.hashCode % 1000;
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    Future.delayed(Duration(milliseconds: phaseOffset), () {
      if (mounted) _idleController.repeat(reverse: true);
    });
  }

  @override
  void didUpdateWidget(covariant _LevelButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted && !oldWidget.isCompleted) {
      _badgeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _releaseController.dispose();
    _badgeController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  double get _scale => _releaseController.status != AnimationStatus.dismissed
      ? _releaseScale.value
      : _pressScale.value;

  void _release() {
    _pressController.value = 0;
    _releaseController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _releaseController.value = 0;
        _pressController.forward();
      },
      onTapUp: (_) => _release(),
      onTapCancel: _release,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _pressController,
          _releaseController,
          _idleController,
        ]),
        builder: (context, child) => Transform.scale(
          scale: _scale,
          child: Container(
            decoration: widget.isCompleted
                ? null
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: 0.18 + _idleController.value * 0.22,
                        ),
                        blurRadius: 10 + _idleController.value * 6,
                        spreadRadius: _idleController.value * 1.5,
                      ),
                    ],
                  ),
            child: child,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.isCompleted
                ? LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.55),
                      AppColors.primaryDark.withValues(alpha: 0.55),
                    ],
                  )
                : AppColors.primaryButtonGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${widget.targetScore}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              if (widget.hasObstacles)
                const Positioned(
                  top: 4,
                  left: 4,
                  child: Icon(
                    Icons.terrain_rounded,
                    color: Colors.white70,
                    size: 14,
                  ),
                ),
              if (widget.isCompleted)
                Positioned(
                  top: 4,
                  right: 4,
                  child: AnimatedBuilder(
                    animation: _badgeScale,
                    builder: (context, child) => Transform.rotate(
                      angle: (1 - _badgeScale.value) * 0.6,
                      child: Transform.scale(
                        scale: _badgeScale.value,
                        child: child,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 16,
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
