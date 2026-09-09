import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A friendly circular icon button matching the app's AppBar badge style,
/// shared across screens (e.g. Home's Settings/Daily Reward actions, the
/// Game screen's back button) instead of each screen rolling its own.
class AppBarIconBadge extends StatelessWidget {
  const AppBarIconBadge({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primaryDark),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
