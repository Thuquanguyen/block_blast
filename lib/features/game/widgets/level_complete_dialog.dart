import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/pop_in.dart';
import '../controllers/game_controller.dart';

class LevelCompleteDialog extends StatelessWidget {
  const LevelCompleteDialog({super.key});

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
                Icons.emoji_events_rounded,
                color: AppColors.accent,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'level_complete_title'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'level_complete_score'.trParams({
                        'score': '${controller.score.value}',
                      }),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'level_complete_journey'.tr,
                icon: Icons.map_rounded,
                onPressed: () {
                  Get.back();
                  Get.back(result: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
