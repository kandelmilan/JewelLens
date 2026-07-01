import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:jewellens/models/login_model.dart';
import 'package:jewellens/models/register_model.dart';
import 'package:jewellens/services/auth_service.dart';
import 'package:jewellens/views/auth_view/login_view.dart';
import 'package:jewellens/views/landing_page.dart';

class AuthController extends GetxController {
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

  //for password eye
  var obscure = true.obs;

  void togglePassword() {
    obscure.value = !obscure.value;
  }

  var obscureConfirm = true.obs;

  void toggleConfirmPassword() {
    obscureConfirm.value = !obscureConfirm.value;
  }

  Future<void> login() async {
    try {
      isLoading(true);
      var response = await AuthService.login(
        email.text.trim(),
        password.text.trim(),
        remember.value,
      );

      loginUser.value = response;

      if (loginUser.value.status == 200) {
        String? token = loginUser.value.data?.token;

        if (token != null) {
          //save the token in storage.
        }
        Get.snackbar(
          "Success",
          loginUser.value.message ?? "Login Successful",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        // Navigate to LoginView after successful registration
        email.clear();
        password.clear();
        loginFormKey.currentState?.reset();
        Get.offAll(() => const HomeView());
      } else {
        Get.snackbar(
          "Error",
          loginUser.value.message ?? "Login Failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      print("ERROR: $e");
      print(stack);

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

  // Register

  Future<void> register() async {
    // Client-side check before hitting the API
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
      var response = await AuthService.register(
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
      print("ERROR: $e");
      print(stack);
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
