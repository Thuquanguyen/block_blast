import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/game_controller.dart';

/// Shows "Combo xN" whenever the streak increments, scaling
/// 0.8 -> 1.25 -> 1.0 while fading out.
class ComboWidget extends StatefulWidget {
  const ComboWidget({super.key});

  @override
  State<ComboWidget> createState() => _ComboWidgetState();
}

class _ComboWidgetState extends State<ComboWidget>
    with SingleTickerProviderStateMixin {
  final GameController controller = Get.find<GameController>();
  late final AnimationController _animController;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  int _displayedCombo = 0;
  Worker? _comboWorker;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.25), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.6, 1.0)),
    );

    _comboWorker = ever<int>(controller.combo, (value) {
      if (value > 1) {
        setState(() => _displayedCombo = value);
        _animController.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    _comboWorker?.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        if (_animController.isDismissed) return const SizedBox.shrink();
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.accentButtonGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'combo_label'.trParams({'combo': '$_displayedCombo'}),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
