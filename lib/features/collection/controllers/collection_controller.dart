import 'package:get/get.dart';

/// Placeholder collection ("Spring Garden") progress. No real unlock logic
/// yet — pieces just render locked until a future pass adds earn/reward
/// wiring.
class CollectionController extends GetxController {
  static const int totalPieces = 20;

  final unlockedPieces = 0.obs;
}
