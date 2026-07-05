import 'dart:async';
import 'package:get/get.dart';
import 'package:jewellens/services/storages/token_storage.dart';
import 'package:jewellens/features/auth/views/login_view.dart';
import 'package:jewellens/features/auth/controller/auth_controller.dart';
import 'package:jewellens/features/profile/controllers/user_controller.dart';

class InactivityService extends GetxService {
  static InactivityService get instance => Get.find<InactivityService>();

  Timer? _timer;
  final Duration timeout = const Duration(minutes: 1);

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
    stopWatching();

    await TokenStorage.instance.clear();

    if (Get.isRegistered<UserController>()) {
      Get.find<UserController>().user.value = null;
    }

    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().clearLoginForm();
    }

    Get.offAll(() => const LoginView());

    Get.snackbar(
      "Session Expired",
      "You were logged out due to inactivity",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
