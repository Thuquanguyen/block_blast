import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/pop_in.dart';
import '../controllers/daily_reward_controller.dart';

class DailyRewardDialog extends GetView<DailyRewardController> {
  const DailyRewardDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                Icons.card_giftcard_rounded,
                color: AppColors.accent,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'daily_reward_title'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.maxFinite,
                child: Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final reward in DailyRewardController.rewards)
                        _buildRewardTile(
                          reward,
                          isActive: reward.day == controller.currentDay.value,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => AppButton(
                  label: controller.claimedToday.value
                      ? 'daily_reward_claimed'.tr
                      : 'daily_reward_claim'.tr,
                  icon: Icons.check_circle_rounded,
                  onPressed: controller.claimedToday.value
                      ? null
                      : () async {
                          await controller.claim();
                          Get.back();
                        },
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'daily_reward_close'.tr,
                outlined: true,
                textColor: AppColors.primaryDark,
                onPressed: Get.back,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardTile(DailyRewardDay reward, {required bool isActive}) {
    return AnimatedScale(
      scale: isActive ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceTint : null,
          borderRadius: BorderRadius.circular(14),
          border: isActive
              ? Border.all(color: AppColors.accent, width: 2)
              : null,
        ),
        child: ListTile(
          dense: true,
          leading: Text(
            'daily_reward_day_label'.trParams({'day': '${reward.day}'}),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isActive ? AppColors.accentDark : AppColors.textPrimary,
            ),
          ),
          title: Text(reward.label.tr),
          trailing: isActive
              ? const Icon(Icons.star_rounded, color: AppColors.accent)
              : null,
        ),
      ),
    );
  }
}
