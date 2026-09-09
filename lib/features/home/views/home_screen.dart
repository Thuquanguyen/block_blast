import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bar_icon_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/banner_ad_slot.dart';
import '../../../core/widgets/floating_blocks_background.dart';
import '../../../core/widgets/mascot_blob.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Block Blast'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: AppBarIconBadge(
            icon: Icons.settings_rounded,
            tooltip: 'home_settings_tooltip'.tr,
            onPressed: controller.openSettings,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppBarIconBadge(
              icon: Icons.card_giftcard_rounded,
              tooltip: 'home_daily_reward_tooltip'.tr,
              onPressed: controller.openDailyReward,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            const FloatingBlocksBackground(),
            Center(child: _HomeContent(controller: controller)),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Center(child: BannerAdSlot()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hosts the two hand-rolled animations for the redesigned home content: a
/// slow continuous bob/rotate on the logo cluster, and a one-shot staggered
/// fade+slide-up entrance for the four nav buttons.
class _HomeContent extends StatefulWidget {
  const _HomeContent({required this.controller});

  final HomeController controller;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _entranceController;

  // Plays once a nav button is tapped: every button flies/fades toward the
  // tapped one (as if the screen is diving into it) before the actual
  // navigation runs, staggered outward from the tapped index.
  late final AnimationController _exitController;
  int? _tappedIndex;

  static const _buttonSpecs = [
    (
      label: 'home_classic_game',
      icon: Icons.play_arrow_rounded,
      gradient: AppColors.primaryButtonGradient,
    ),
    (
      label: 'home_journey',
      icon: Icons.map_rounded,
      gradient: LinearGradient(
        colors: [Color(0xFF35C2C1), Color(0xFF1E9E9D)],
      ),
    ),
    (
      label: 'home_collection',
      icon: Icons.grid_view_rounded,
      gradient: LinearGradient(
        colors: [Color(0xFFFF9F6B), Color(0xFFFF7A3D)],
      ),
    ),
    (
      label: 'home_leaderboard',
      icon: Icons.leaderboard_rounded,
      gradient: LinearGradient(
        colors: [Color(0xFFE07BE0), Color(0xFFB84FD1)],
      ),
    ),
  ];

  static const _exitDuration = Duration(milliseconds: 380);

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _exitController = AnimationController(vsync: this, duration: _exitDuration);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _entranceController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  Animation<double> _staggerFor(int index) {
    final start = index * 0.08;
    return CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, start + 0.5, curve: Curves.easeOut),
    );
  }

  /// Distance-staggered exit slice for button [index], rippling outward from
  /// whichever button was tapped.
  Animation<double> _exitFor(int index) {
    final distance = (index - (_tappedIndex ?? index)).abs();
    final start = (distance * 0.12).clamp(0.0, 0.6);
    return CurvedAnimation(
      parent: _exitController,
      curve: Interval(start, 1.0, curve: Curves.easeIn),
    );
  }

  void _handleTap(int index, VoidCallback callback) {
    if (_tappedIndex != null) return;
    setState(() => _tappedIndex = index);
    _exitController.forward(from: 0).whenComplete(callback);
  }

  @override
  Widget build(BuildContext context) {
    // If we're the current route again with a finished exit animation, it
    // means the player navigated away (buttons flew out) and has since come
    // back (e.g. via the back arrow) — bring the buttons back instead of
    // leaving them permanently scattered/invisible.
    final route = ModalRoute.of(context);
    if (_tappedIndex != null &&
        !_exitController.isAnimating &&
        (route?.isCurrent ?? false)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _exitController.value = 0;
          setState(() => _tappedIndex = null);
        }
      });
    }

    final callbacks = [
      widget.controller.playClassicGame,
      widget.controller.openJourney,
      widget.controller.openCollection,
      widget.controller.openLeaderboard,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            _TitleGlow(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BlockLogoMark(animation: _logoController),
                const SizedBox(height: 12),
                const _GradientTitle(),
              ],
            ),
            const Positioned(
              right: -30,
              bottom: -8,
              child: MascotBlob(size: 56),
            ),
          ],
        ),
        const SizedBox(height: 40),
        for (var i = 0; i < _buttonSpecs.length; i++) ...[
          if (i != 0) const SizedBox(height: 14),
          _StaggeredButton(
            animation: _staggerFor(i),
            exitAnimation: _exitFor(i),
            isTapped: _tappedIndex == i,
            direction: _tappedIndex == null || i == _tappedIndex
                ? 0.0
                : (i < _tappedIndex! ? -1.0 : 1.0),
            child: SizedBox(
              width: 260,
              child: AppButton(
                label: _buttonSpecs[i].label.tr,
                icon: _buttonSpecs[i].icon,
                gradient: _buttonSpecs[i].gradient,
                iconBadge: true,
                onPressed: () => _handleTap(i, callbacks[i]),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Soft radial glow sitting behind the logo + title to add depth.
class _TitleGlow extends StatelessWidget {
  const _TitleGlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.55),
            Colors.white.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

/// Decorative tetromino-like cluster of colored rounded squares, reusing the
/// in-game block palette. Gently bobs and rotates in a slow 4s loop.
class _BlockLogoMark extends StatelessWidget {
  const _BlockLogoMark({required this.animation});

  final Animation<double> animation;

  static final _colors = AppConstants.blockColors.take(5).toList();

  static const _cells = [
    Offset(0, 0),
    Offset(1, 0),
    Offset(1, 1),
    Offset(2, 1),
    Offset(0, -1),
  ];

  @override
  Widget build(BuildContext context) {
    const cellSize = 22.0;
    const gap = 3.0;
    return SizedBox(
      width: 90,
      height: 90,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final t = sin(animation.value * pi);
          return Transform.translate(
            offset: Offset(0, -t * 4),
            child: Transform.rotate(angle: (t - 0.5) * 0.06, child: child),
          );
        },
        child: Center(
          child: Stack(
            children: [
              for (var i = 0; i < _cells.length; i++)
                Positioned(
                  left: 45 + _cells[i].dx * (cellSize + gap) - cellSize / 2,
                  top: 45 + _cells[i].dy * (cellSize + gap) - cellSize / 2,
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: _colors[i],
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: _colors[i].withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
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

/// "Block Blast" wordmark: a blurred glow copy behind a crisp gradient-fill
/// copy on top, for a premium mobile-game logo feel.
class _GradientTitle extends StatelessWidget {
  const _GradientTitle();

  static const _text = 'Block Blast';

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(
      context,
    ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800);
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          _text,
          style: baseStyle?.copyWith(
            foreground: Paint()
              ..color = AppColors.primary.withValues(alpha: 0.55)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryButtonGradient.createShader(bounds),
          child: Text(_text, style: baseStyle?.copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}

/// Fades and slides a nav button up into place on entrance (via [animation]),
/// and — once a button is tapped — animates it out again via [exitAnimation]:
/// the tapped button grows and fades as if the screen dives into it, while
/// the rest scatter sideways and shrink away, staggered outward from it.
class _StaggeredButton extends StatelessWidget {
  const _StaggeredButton({
    required this.animation,
    required this.exitAnimation,
    required this.isTapped,
    required this.direction,
    required this.child,
  });

  final Animation<double> animation;
  final Animation<double> exitAnimation;
  final bool isTapped;

  /// -1/0/1: which way this button scatters on exit relative to the tapped
  /// one (0 for the tapped button itself, which grows in place instead).
  final double direction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([animation, exitAnimation]),
      builder: (context, child) {
        final entrance = animation.value;
        final exit = exitAnimation.value;
        final scale = isTapped
            ? 1.0 + exit * 0.5
            : 1.0 - exit * 0.35;
        final dx = direction * (exit * exit) * 60;
        return Opacity(
          opacity: (entrance * (1 - exit)).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(dx, (1 - entrance) * 18),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: child,
    );
  }
}
