import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Small hand-drawn "blob" mascot for the Home screen — built entirely from
/// shapes (no image assets). Idles with a gentle squash-and-stretch bounce
/// loop and blinks its dot eyes every few seconds for a bit of character.
class MascotBlob extends StatefulWidget {
  const MascotBlob({super.key, this.size = 72});

  final double size;

  @override
  State<MascotBlob> createState() => _MascotBlobState();
}

class _MascotBlobState extends State<MascotBlob> with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final AnimationController _blinkController;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scheduleBlink();
  }

  void _scheduleBlink() {
    _blinkTimer = Timer(
      Duration(milliseconds: 2600 + Random().nextInt(1800)),
      () {
        if (!mounted) return;
        _blinkController.forward().then((_) {
          if (mounted) _blinkController.reverse();
        });
        _scheduleBlink();
      },
    );
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _bounceController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return SizedBox(
      width: size * 1.4,
      height: size * 1.6,
      child: AnimatedBuilder(
        animation: Listenable.merge([_bounceController, _blinkController]),
        builder: (context, child) {
          // 0 -> 1 -> 0 across the bounce cycle: peak lift/stretch mid-cycle.
          final t = sin(_bounceController.value * pi);
          final lift = t * size * 0.16;
          final stretchY = 1 + t * 0.08;
          final squashX = 1 - t * 0.06;
          final eyeScaleY = 1 - _blinkController.value;
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 4,
                child: Opacity(
                  opacity: 0.25 - t * 0.1,
                  child: Container(
                    width: size * (0.7 - t * 0.12),
                    height: size * 0.16,
                    decoration: const BoxDecoration(
                      color: AppColors.shadow,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -lift),
                child: Transform.scale(
                  scaleX: squashX,
                  scaleY: stretchY,
                  child: _BlobBody(size: size, eyeScaleY: eyeScaleY),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BlobBody extends StatelessWidget {
  const _BlobBody({required this.size, required this.eyeScaleY});

  final double size;
  final double eyeScaleY;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: -size * 0.08,
            top: size * 0.42,
            child: Container(
              width: size * 0.22,
              height: size * 0.14,
              decoration: BoxDecoration(
                color: AppColors.accentDark,
                borderRadius: BorderRadius.circular(size),
              ),
            ),
          ),
          Positioned(
            right: -size * 0.08,
            top: size * 0.42,
            child: Container(
              width: size * 0.22,
              height: size * 0.14,
              decoration: BoxDecoration(
                color: AppColors.accentDark,
                borderRadius: BorderRadius.circular(size),
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: AppColors.accentButtonGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: size * 0.08),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Eye(size: size, scaleY: eyeScaleY),
                    SizedBox(width: size * 0.22),
                    _Eye(size: size, scaleY: eyeScaleY),
                  ],
                ),
                SizedBox(height: size * 0.08),
                CustomPaint(
                  size: Size(size * 0.28, size * 0.14),
                  painter: _SmilePainter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  const _Eye({required this.size, required this.scaleY});

  final double size;
  final double scaleY;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleY: scaleY.clamp(0.08, 1.0),
      child: Container(
        width: size * 0.1,
        height: size * 0.1,
        decoration: const BoxDecoration(
          color: AppColors.textPrimary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Draws a single simple curved smile using a quadratic bezier stroke.
class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SmilePainter oldDelegate) => false;
}
