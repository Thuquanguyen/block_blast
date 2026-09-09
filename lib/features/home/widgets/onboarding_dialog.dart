import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/pop_in.dart';

class _OnboardingStep {
  const _OnboardingStep(this.title, this.description, this.icon);

  final String title;
  final String description;
  final IconData icon;
}

const _steps = [
  _OnboardingStep(
    'onboarding_step1_title',
    'onboarding_step1_desc',
    Icons.pan_tool_alt_rounded,
  ),
  _OnboardingStep(
    'onboarding_step2_title',
    'onboarding_step2_desc',
    Icons.view_week_rounded,
  ),
  _OnboardingStep(
    'onboarding_step3_title',
    'onboarding_step3_desc',
    Icons.auto_awesome_rounded,
  ),
];

/// First-launch-only 3-step tutorial shown before the first Classic Game
/// session. Calls [onFinish] once the player taps through all steps.
class OnboardingDialog extends StatefulWidget {
  const OnboardingDialog({super.key, required this.onFinish});

  final VoidCallback onFinish;

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  int _stepIndex = 0;

  void _next() {
    if (_stepIndex < _steps.length - 1) {
      setState(() => _stepIndex++);
    } else {
      widget.onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_stepIndex];
    final isLastStep = _stepIndex == _steps.length - 1;
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
              Icon(step.icon, color: AppColors.primary, size: 48),
              const SizedBox(height: 8),
              Text(
                step.title.tr,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(step.description.tr, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              AppButton(
                label: isLastStep
                    ? 'onboarding_lets_play'.tr
                    : 'onboarding_next'.tr,
                icon: isLastStep
                    ? Icons.play_arrow_rounded
                    : Icons.arrow_forward_rounded,
                onPressed: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
