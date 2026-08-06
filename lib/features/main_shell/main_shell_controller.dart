import 'package:get/get.dart';

/// Controls the bottom-nav shell. Other screens (e.g. Home's
/// "View all") can switch tabs by calling [switchTo].
class MainShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void switchTo(int index) => currentIndex.value = index;
}
