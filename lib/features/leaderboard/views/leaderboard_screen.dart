import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bar_icon_badge.dart';
import '../../../core/widgets/banner_ad_slot.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  final LeaderboardController controller = Get.find<LeaderboardController>();
  late final AnimationController _entranceController;

  // Plays once when the list first has entries to show; re-triggering on
  // every unrelated Obx rebuild would replay the stagger constantly.
  bool _entrancePlayed = false;

  static const _staggerStep = 0.05;
  static const _itemSpan = 0.5;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Animation<double> _staggerFor(int index) {
    final start = (index * _staggerStep).clamp(0.0, 1.0 - _itemSpan);
    return CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, start + _itemSpan, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('leaderboard_title'.tr),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: AppBarIconBadge(
            icon: Icons.arrow_back_rounded,
            tooltip: 'game_back_tooltip'.tr,
            onPressed: Get.back,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!_entrancePlayed && controller.entries.isNotEmpty) {
              _entrancePlayed = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _entranceController.forward(from: 0);
              });
            }
            return Column(
              children: [
                if (controller.myRank.value != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _MyRankCard(
                      rank: controller.myRank.value!,
                      score: controller.myScore.value ?? 0,
                    ),
                  ),
                Expanded(
                  child: controller.entries.isEmpty
                      ? Center(
                          child: Text(
                            'leaderboard_no_scores'.tr,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.entries.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final entry = controller.entries[index];
                            final isMe = entry.uid == controller.myUid.value;
                            final tile = _LeaderboardTile(
                              rank: index + 1,
                              nickname: entry.nickname,
                              score: entry.score,
                              highlighted: isMe,
                            );
                            return _FadeSlideIn(
                              animation: _staggerFor(index),
                              child: tile,
                            );
                          },
                        ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: BannerAdSlot(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

/// Fades and slides [child] up into place as [animation] runs from 0 to 1.
class _FadeSlideIn extends StatelessWidget {
  const _FadeSlideIn({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - animation.value) * 18),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

class _MyRankCard extends StatelessWidget {
  const _MyRankCard({required this.rank, required this.score});

  final int rank;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            'leaderboard_my_rank'.trParams({
              'rank': '$rank',
              'score': '$score',
            }),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gold/silver/bronze badge colors for the top-3 leaderboard ranks.
const _medalColors = {
  1: Color(0xFFFFD700),
  2: Color(0xFFC0C0C0),
  3: Color(0xFFCD7F32),
};

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({
    required this.rank,
    required this.nickname,
    required this.score,
    required this.highlighted,
  });

  final int rank;
  final String nickname;
  final int score;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final medalColor = _medalColors[rank];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.surfaceTint : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: highlighted
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: medalColor != null
                ? Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: medalColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: medalColor,
                      size: 18,
                    ),
                  )
                : Text(
                    '#$rank',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
          Expanded(
            child: Text(
              nickname.isEmpty ? 'leaderboard_player_fallback'.tr : nickname,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$score',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
