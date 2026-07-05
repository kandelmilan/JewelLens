import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:jewellens/features/auth/models/login_model.dart';
import 'package:jewellens/features/auth/models/register_model.dart';
import 'package:jewellens/features/auth/repositories/auth_repository.dart';
import 'package:jewellens/features/profile/controllers/user_controller.dart';
import 'package:jewellens/services/inactivity/inactivity_service.dart';
import 'package:jewellens/services/storages/token_storage.dart';
import 'package:jewellens/features/auth/views/login_view.dart';
import 'package:jewellens/features/main_nav/main_nav_view.dart';

class AuthController extends GetxController {
  // Controller now depends on the AuthRepository interface, not AuthService.
  // To unit test this controller, pass in a fake AuthRepository — no Dio,
  // no network, no mocking HTTP required.
  final AuthRepository _authRepository;

  AuthController({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepositoryImpl();

  var isLoading = false.obs;
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var remember = false.obs;

  var loginUser = LoginModel(status: null, message: null, data: null).obs;
  var registerUser = RegisterModel(status: null, message: null, data: null).obs;

  var name = TextEditingController();
  var address = TextEditingController();
  var phone = TextEditingController();
  var confirmPassword = TextEditingController();
  var acceptTerms = false.obs;

  var obscure = true.obs;
  void togglePassword() => obscure.value = !obscure.value;

  var obscureConfirm = true.obs;
  void toggleConfirmPassword() => obscureConfirm.value = !obscureConfirm.value;
  void clearLoginForm() {
    email.clear();
    password.clear();
    remember.value = false;
    loginFormKey.currentState?.reset();
  }

  Future<void> login() async {
    try {
      isLoading(true);

      // Was: AuthService.login(...) — now goes through the repository.
      final response = await _authRepository.login(
        email.text.trim(),
        password.text.trim(),
        remember.value,
      );

      loginUser.value = response;

      if (loginUser.value.status == 200) {
        final String? token = loginUser.value.data?.token;

        if (token == null || token.isEmpty) {
          Get.snackbar(
            "Login Failed",
            "No token received. Please try again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        await TokenStorage.instance.saveAccessToken(token);

        // Verify the token was actually saved
        final savedToken = await TokenStorage.instance.getAccessToken();

        debugPrint("Received Token : $token");
        debugPrint("Saved Token    : $savedToken");

        if (savedToken != null && savedToken.isNotEmpty) {
          Get.snackbar(
            "Success",
            loginUser.value.message ?? "Login Successful",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          email.clear();
          password.clear();
          loginFormKey.currentState?.reset();
          if (Get.isRegistered<UserController>()) {
            await Get.find<UserController>().getUser();
          }

          InactivityService.instance.startWatching();

          Get.offAll(() => const MainNavView());
        } else {
          Get.snackbar(
            "Login Error",
            "Failed to save access token.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e, stack) {
      debugPrint("ERROR: $e");
      debugPrint(stack.toString());
      Get.snackbar(
        "Exception",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> register() async {
    if (password.text.trim() != confirmPassword.text.trim()) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!acceptTerms.value) {
      Get.snackbar(
        "Error",
        "Please accept the terms and conditions",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      // Was: AuthService.register(...) — now goes through the repository.
      final response = await _authRepository.register(
        name.text.trim(),
        email.text.trim(),
        password.text.trim(),
        confirmPassword.text.trim(),
        phone.text.trim(),
        address.text.trim(),
        acceptTerms.value,
      );

      registerUser.value = response;

      if (registerUser.value.status == 200 ||
          registerUser.value.status == 201) {
        Get.snackbar(
          "Success",
          registerUser.value.message ?? "Registration Successful",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        Get.offAll(() => const LoginView());
      } else {
        Get.snackbar(
          "Error",
          registerUser.value.message ?? "Registration Failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      String friendlyMessage;

      if (e.response?.statusCode == 409) {
        friendlyMessage =
            e.response?.data?['message'] ??
            "An account with this email or phone already exists.";
      } else if (e.response != null) {
        friendlyMessage =
            e.response?.data?['message'] ??
            "Something went wrong. Please try again.";
      } else {
        friendlyMessage = "No internet connection. Please check your network.";
      }

      Get.snackbar(
        "Registration Failed",
        friendlyMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e, stack) {
      debugPrint("ERROR: $e");
      debugPrint(stack.toString());
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    final bool? confirm = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFFFEBEE),
                child: Icon(Icons.logout_rounded, color: Colors.red, size: 30),
              ),

              const SizedBox(height: 20),

              const Text(
                "Logout",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Are you sure you want to logout from your account?",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Get.back(result: true),
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm != true) return;

    InactivityService.instance.stopWatching();

    await TokenStorage.instance.clear();
    clearLoginForm();
    // Clear cached user profile
    if (Get.isRegistered<UserController>()) {
      Get.find<UserController>().user.value = null;
    }

    Get.offAll(() => const LoginView());

    Get.snackbar(
      "Logged Out",
      "You have been logged out successfully.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    name.dispose();
    address.dispose();
    phone.dispose();
    super.onClose();
  }
}
