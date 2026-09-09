import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// Pill-shaped button with a gradient fill, soft shadow, a light press-in
/// scale (1.0 -> 0.96) and a springy release bounce (0.96 -> 1.04 -> 1.0).
/// Used across the app in place of the default Material [ElevatedButton].
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient = AppColors.primaryButtonGradient,
    this.textColor = Colors.white,
    this.height = 52,
    this.outlined = false,
    this.iconBadge = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient gradient;
  final Color textColor;
  final double height;

  /// Renders as a flat, low-emphasis pill (light surface fill, no shadow)
  /// for secondary dialog actions instead of the gradient-filled look.
  final bool outlined;

  /// Wraps [icon] in a small translucent white circle badge instead of
  /// placing the glyph bare on the gradient. Defaults to false so existing
  /// callers keep their current look.
  final bool iconBadge;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with TickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _pressScale;

  // Plays on release: overshoots past 1.0 before settling, for a springier,
  // more toy-like feel than a plain reverse of the press-in scale.
  late final AnimationController _releaseController;
  late final Animation<double> _releaseScale;

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
  }

  @override
  void dispose() {
    _pressController.dispose();
    _releaseController.dispose();
    super.dispose();
  }

  double get _scale => _releaseController.status != AnimationStatus.dismissed
      ? _releaseScale.value
      : _pressScale.value;

  bool get _enabled => widget.onPressed != null;

  void _onTapDown(TapDownDetails details) {
    if (!_enabled) return;
    _releaseController.value = 0;
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) => _release();

  void _onTapCancel() => _release();

  void _release() {
    _pressController.value = 0;
    _releaseController.forward(from: 0);
  }

  void _onTap() {
    if (!_enabled) return;
    HapticFeedback.lightImpact();
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pressController, _releaseController]),
        builder: (context, child) =>
            Transform.scale(scale: _scale, child: child),
        child: Opacity(
          opacity: _enabled ? 1.0 : 0.5,
          child: Container(
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              gradient: widget.outlined ? null : widget.gradient,
              color: widget.outlined ? AppColors.surfaceTint : null,
              borderRadius: BorderRadius.circular(widget.height / 2),
              boxShadow: widget.outlined
                  ? null
                  : const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  widget.iconBadge
                      ? Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.textColor,
                            size: 16,
                          ),
                        )
                      : Icon(widget.icon, color: widget.textColor, size: 22),
                  const SizedBox(width: 10),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
