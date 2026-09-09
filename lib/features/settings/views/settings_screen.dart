import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bar_icon_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/banner_ad_slot.dart';
import '../../../core/widgets/pop_in.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final SettingsController controller = Get.find<SettingsController>();
  late final AnimationController _entranceController;

  static const _staggerStep = 0.06;
  static const _itemSpan = 0.5;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
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

  Widget _staggered(int index, Widget child) {
    return _FadeSlideIn(animation: _staggerFor(index), child: child);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings_title'.tr),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _staggered(
              0,
              Obx(
                () => _SettingsSwitchTile(
                  icon: Icons.volume_up_rounded,
                  title: 'settings_sound'.tr,
                  value: controller.soundEnabled.value,
                  onChanged: controller.toggleSound,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _staggered(
              1,
              Obx(
                () => _SettingsSwitchTile(
                  icon: Icons.music_note_rounded,
                  title: 'settings_music'.tr,
                  value: controller.musicEnabled.value,
                  onChanged: controller.toggleMusic,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _staggered(
              2,
              Obx(
                () => _SettingsSwitchTile(
                  icon: Icons.vibration_rounded,
                  title: 'settings_haptic'.tr,
                  value: controller.hapticEnabled.value,
                  onChanged: controller.toggleHaptic,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _staggered(
              3,
              Obx(
                () => _SettingsTile(
                  icon: Icons.person_rounded,
                  title: 'settings_nickname'.tr,
                  trailing: Text(
                    controller.nickname.value.isEmpty
                        ? 'settings_nickname_not_set'.tr
                        : controller.nickname.value,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  onTap: () => _showNicknameDialog(context, controller),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _staggered(
              4,
              _SettingsTile(
                icon: Icons.notifications_rounded,
                title: 'settings_notifications'.tr,
              ),
            ),
            // "Restore Purchase" / "Remove Ads" are hidden for now: IapService
            // is still a local-only stub (no real StoreKit/Play Billing
            // product configured in App Store Connect / Play Console yet — see
            // lib/services/iap_service.dart). Showing these would let a
            // player tap a "purchase" that doesn't actually charge anything
            // real, which is misleading and would also fail App Store review.
            // Restore both tiles (and the SizedBox(height: 12) spacers around
            // them) once a real IAP product exists.
            const SizedBox(height: 12),
            _staggered(
              5,
              _SettingsTile(
                icon: Icons.star_rounded,
                title: 'settings_rate_us'.tr,
              ),
            ),
            const SizedBox(height: 12),
            _staggered(
              6,
              _SettingsTile(
                icon: Icons.privacy_tip_rounded,
                title: 'settings_privacy_policy'.tr,
              ),
            ),
            const SizedBox(height: 12),
            _staggered(
              7,
              _SettingsTile(
                icon: Icons.description_rounded,
                title: 'settings_terms'.tr,
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: BannerAdSlot()),
          ],
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

void _showNicknameDialog(BuildContext context, SettingsController controller) {
  final textController = TextEditingController(text: controller.nickname.value);
  Get.dialog(
    Dialog(
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
              Text(
                'settings_nickname'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLength: 24,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'settings_nickname_hint'.tr,
                ),
              ),
              const SizedBox(height: 8),
              AppButton(
                label: 'settings_save'.tr,
                height: 44,
                onPressed: () {
                  controller.updateNickname(textController.text.trim());
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing:
            trailing ??
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
