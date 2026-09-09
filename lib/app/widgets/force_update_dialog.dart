import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/pop_in.dart';

/// Non-dismissible dialog shown when RemoteConfigService.isUpdateRequired
/// is true. Blocks the player from proceeding until they update.
class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
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
                  Icons.system_update_rounded,
                  color: AppColors.accent,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'force_update_title'.tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'force_update_message'.tr,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: 'force_update_button'.tr,
                  icon: Icons.arrow_upward_rounded,
                  // TODO: launch the App Store / Play Store listing once one
                  // exists — no url_launcher package added yet for this task.
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
