import 'package:flutter/material.dart';

class _FloatingBlockSpec {
  const _FloatingBlockSpec({
    required this.left,
    required this.top,
    required this.size,
    required this.color,
    required this.duration,
    required this.travel,
    this.opacity = 0.55,
  });

  final double left;
  final double top;
  final double size;
  final Color color;
  final Duration duration;
  final double travel;
  final double opacity;
}

const _blocks = [
  _FloatingBlockSpec(
    left: 0.08,
    top: 0.12,
    size: 46,
    color: Color(0xFFFFC98B),
    duration: Duration(milliseconds: 4200),
    travel: 22,
  ),
  _FloatingBlockSpec(
    left: 0.78,
    top: 0.2,
    size: 34,
    color: Color(0xFFAEE6FF),
    duration: Duration(milliseconds: 3600),
    travel: 18,
  ),
  _FloatingBlockSpec(
    left: 0.15,
    top: 0.68,
    size: 30,
    color: Color(0xFFC9B8FF),
    duration: Duration(milliseconds: 5000),
    travel: 20,
  ),
  _FloatingBlockSpec(
    left: 0.82,
    top: 0.72,
    size: 40,
    color: Color(0xFFFFB4C6),
    duration: Duration(milliseconds: 4600),
    travel: 24,
  ),
  _FloatingBlockSpec(
    left: 0.05,
    top: 0.42,
    size: 20,
    color: Color(0xFFBFF7D6),
    duration: Duration(milliseconds: 3900),
    travel: 14,
    opacity: 0.4,
  ),
  _FloatingBlockSpec(
    left: 0.9,
    top: 0.48,
    size: 26,
    color: Color(0xFFFFE39B),
    duration: Duration(milliseconds: 5300),
    travel: 16,
    opacity: 0.45,
  ),
];

/// A handful of soft colored squares drifting slowly up/down behind the
/// Home screen content — cheap decorative motion, not a particle system.
class FloatingBlocksBackground extends StatefulWidget {
  const FloatingBlocksBackground({super.key});

  @override
  State<FloatingBlocksBackground> createState() =>
      _FloatingBlocksBackgroundState();
}

class _FloatingBlocksBackgroundState extends State<FloatingBlocksBackground>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [
      for (final block in _blocks)
        AnimationController(vsync: this, duration: block.duration)
          ..repeat(reverse: true),
    ];
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return IgnorePointer(
          child: Stack(
            children: [
              for (var i = 0; i < _blocks.length; i++)
                AnimatedBuilder(
                  animation: _controllers[i],
                  builder: (context, child) {
                    final block = _blocks[i];
                    final dy = -_controllers[i].value * block.travel;
                    return Positioned(
                      left: constraints.maxWidth * block.left,
                      top: constraints.maxHeight * block.top + dy,
                      child: child!,
                    );
                  },
                  child: Container(
                    width: _blocks[i].size,
                    height: _blocks[i].size,
                    decoration: BoxDecoration(
                      color: _blocks[i].color.withValues(
                        alpha: _blocks[i].opacity,
                      ),
                      borderRadius: BorderRadius.circular(
                        _blocks[i].size * 0.3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
