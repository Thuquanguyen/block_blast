import 'dart:math';

import 'package:flutter/material.dart';

/// Hand-rolled state for a single flying square spawned by a line clear.
class _Particle {
  _Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.rotationSpeed,
  });

  Offset position;
  Offset velocity;
  final Color color;
  final double rotationSpeed;
  double rotation = 0;
  double scale = 1;
  double opacity = 1;
}

/// Caps the total particles a single burst can spawn (spec: "don't use too
/// many particles"), even when several lines clear at once.
const _maxParticlesPerBurst = 80;
const _minParticlesPerCell = 8;
const _maxParticlesPerCell = 15;

const _gravity = 500.0; // px/s^2
const _burstDuration = Duration(milliseconds: 350);

/// A one-shot particle burst animation for the cells cleared by a single
/// placement. Removes itself via [onComplete] once done.
class ClearBurstOverlay extends StatefulWidget {
  const ClearBurstOverlay({
    super.key,
    required this.cells,
    required this.colors,
    required this.cellSize,
    required this.onComplete,
  });

  final List<(int, int)> cells;
  final List<Color> colors;
  final double cellSize;
  final VoidCallback onComplete;

  @override
  State<ClearBurstOverlay> createState() => _ClearBurstOverlayState();
}

class _ClearBurstOverlayState extends State<ClearBurstOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _random = Random();
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _burstDuration)
      ..addListener(_step)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onComplete();
      });
    _spawnParticles();
    _controller.forward();
  }

  void _spawnParticles() {
    final cellCount = widget.cells.length.clamp(1, widget.cells.length);
    final perCell = (_maxParticlesPerBurst / cellCount)
        .clamp(_minParticlesPerCell, _maxParticlesPerCell)
        .round();

    for (var i = 0; i < widget.cells.length; i++) {
      if (_particles.length >= _maxParticlesPerBurst) break;
      final (row, col) = widget.cells[i];
      final color = widget.colors.length > i ? widget.colors[i] : Colors.white;
      final center = Offset(
        (col + 0.5) * widget.cellSize,
        (row + 0.5) * widget.cellSize,
      );

      for (
        var p = 0;
        p < perCell && _particles.length < _maxParticlesPerBurst;
        p++
      ) {
        final angle = _random.nextDouble() * 2 * pi;
        final speed = 60 + _random.nextDouble() * 120;
        _particles.add(
          _Particle(
            position: center,
            velocity: Offset(cos(angle), sin(angle)) * speed,
            color: color,
            rotationSpeed: (_random.nextDouble() - 0.5) * 10,
          ),
        );
      }
    }
  }

  void _step() {
    final dt = 1 / 60;
    for (final particle in _particles) {
      particle.velocity += Offset(0, _gravity * dt);
      particle.position += particle.velocity * dt;
      particle.rotation += particle.rotationSpeed * dt;
      particle.opacity = (1 - _controller.value).clamp(0, 1);
      particle.scale = (1 - _controller.value * 0.7).clamp(0, 1);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ParticlePainter(_particles),
        size: Size.infinite,
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.particles);

  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    const particleSize = 6.0;
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity);
      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);
      canvas.scale(particle.scale);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particleSize,
          height: particleSize,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
