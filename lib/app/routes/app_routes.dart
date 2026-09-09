part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const GAME = _Paths.GAME;
  static const JOURNEY = _Paths.JOURNEY;
  static const COLLECTION = _Paths.COLLECTION;
  static const SETTINGS = _Paths.SETTINGS;
  static const LEADERBOARD = _Paths.LEADERBOARD;
}

abstract class _Paths {
  _Paths._();

  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const GAME = '/game';
  static const JOURNEY = '/journey';
  static const COLLECTION = '/collection';
  static const SETTINGS = '/settings';
  static const LEADERBOARD = '/leaderboard';
}
