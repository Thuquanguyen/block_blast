import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/ad_service.dart';

/// Loads and displays a banner ad, per the project's ad-placement rule:
/// shown on menu screens (Home/Journey/Collection/Settings), never during
/// gameplay. Collapses to nothing while loading/unavailable so it never
/// reserves dead space or shifts layout.
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({super.key});

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  final _adService = Get.find<AdService>();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _adService.loadBanner(
      onLoaded: () {
        if (mounted) setState(() => _loaded = true);
      },
      onFailed: () {
        if (mounted) setState(() => _loaded = false);
      },
    );
  }

  @override
  void dispose() {
    _adService.hideBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _adService.bannerAd;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
