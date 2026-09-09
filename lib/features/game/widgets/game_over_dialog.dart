import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/pop_in.dart';
import '../../../services/ad_service.dart';
import '../controllers/game_controller.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    return Dialog(
      backgroundColor: Colors.transparent,
      child: PopIn(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.sports_score_rounded,
                color: AppColors.accent,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'game_over_title'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bolt_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'game_over_score'.trParams({
                            'score': '${controller.score.value}',
                          }),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.emoji_events_rounded,
                          size: 16,
                          color: AppColors.accentDark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'game_over_best'.trParams({
                            'score': '${controller.bestScore.value}',
                          }),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => controller.reviveUsed.value
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppButton(
                          label: 'game_over_watch_ad'.tr,
                          icon: Icons.videocam_rounded,
                          gradient: AppColors.accentButtonGradient,
                          onPressed: () {
                            Get.back();
                            Get.find<AdService>().showRewarded(
                              controller.revive,
                            );
                          },
                        ),
                      ),
              ),
              AppButton(
                label: 'game_over_new_game'.tr,
                icon: Icons.replay_rounded,
                onPressed: () {
                  Get.back();
                  controller.startNewGameAfterGameOver();
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'game_over_home'.tr,
                icon: Icons.home_rounded,
                outlined: true,
                textColor: AppColors.primaryDark,
                onPressed: () => Get.offAllNamed(Routes.HOME),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
