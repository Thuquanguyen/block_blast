import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/banner_ad_slot.dart';
import '../controllers/collection_controller.dart';

class CollectionScreen extends GetView<CollectionController> {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('collection_title'.tr)),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(
                  () => Text(
                    'collection_progress_label'.trParams({
                      'unlocked': '${controller.unlockedPieces.value}',
                      'total': '${CollectionController.totalPieces}',
                    }),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: CollectionController.totalPieces,
                  itemBuilder: (context, index) {
                    return _LockedPieceTile(index: index);
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

/// A locked "Spring Garden" piece tile: static lock icon plus a diagonal
/// highlight sweep that loops every few seconds, staggered by [index] so the
/// grid doesn't shimmer in unison — an "unlock me" affordance.
class _LockedPieceTile extends StatefulWidget {
  const _LockedPieceTile({required this.index});

  final int index;

  @override
  State<_LockedPieceTile> createState() => _LockedPieceTileState();
}

class _LockedPieceTileState extends State<_LockedPieceTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    Future.delayed(Duration(milliseconds: 200 * widget.index), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            const Icon(Icons.lock_rounded, color: AppColors.textSecondary),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value;
                return Positioned.fill(
                  child: FractionalTranslation(
                    translation: Offset(-1.6 + t * 3.2, -1.6 + t * 3.2),
                    child: Transform.rotate(
                      angle: 0.6,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.5),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
