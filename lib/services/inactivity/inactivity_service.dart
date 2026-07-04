import 'dart:async';
import 'package:get/get.dart';
import 'package:jewellens/services/storages/token_storage.dart';
import 'package:jewellens/features/auth/views/login_view.dart';

class InactivityService extends GetxService {
  static InactivityService get instance => Get.find<InactivityService>();

  Timer? _timer;
  final Duration timeout = const Duration(minutes: 5);

  void startWatching() {
    _resetTimer();
  }

  void registerInteraction() {
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(timeout, _onTimeout);
  }

  void stopWatching() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _onTimeout() async {
    await TokenStorage.instance.clear();

    Get.offAll(() => const LoginView());

    Get.snackbar(
      "Session Expired",
      "You were logged out due to inactivity",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
