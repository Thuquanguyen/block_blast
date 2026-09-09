import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Must be eager (not lazyPut): SplashScreen's build() never reads
    // `controller` (it has nothing to display from it), so the lazy factory
    // would never resolve and onReady()'s navigation timer would never start.
    Get.put(SplashController());
  }
}
