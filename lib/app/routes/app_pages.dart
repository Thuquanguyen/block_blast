import 'package:get/get.dart';

import '../../features/collection/bindings/collection_binding.dart';
import '../../features/collection/views/collection_screen.dart';
import '../../features/game/bindings/game_binding.dart';
import '../../features/game/views/game_view.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/journey/bindings/journey_binding.dart';
import '../../features/journey/views/journey_screen.dart';
import '../../features/leaderboard/bindings/leaderboard_binding.dart';
import '../../features/leaderboard/views/leaderboard_screen.dart';
import '../../features/settings/bindings/settings_binding.dart';
import '../../features/settings/views/settings_screen.dart';
import '../../features/splash/bindings/splash_binding.dart';
import '../../features/splash/views/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.GAME,
      page: () => const GameView(),
      binding: GameBinding(),
    ),
    GetPage(
      name: _Paths.JOURNEY,
      page: () => const JourneyScreen(),
      binding: JourneyBinding(),
    ),
    GetPage(
      name: _Paths.COLLECTION,
      page: () => const CollectionScreen(),
      binding: CollectionBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.LEADERBOARD,
      page: () => const LeaderboardScreen(),
      binding: LeaderboardBinding(),
    ),
  ];
}
