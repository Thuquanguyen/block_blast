import 'package:get/get.dart';

import '../routes/app_pages.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    for (final page in AppPages.routes) {
      page.binding?.dependencies();
    }
  }
}
