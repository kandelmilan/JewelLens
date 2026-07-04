import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jewellens/features/auth/views/login_view.dart';
import 'package:jewellens/services/storages/token_storage.dart';


class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorage.instance.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await TokenStorage.instance.clear();
      Get.offAll(() => const LoginView());

      Get.snackbar(
        "Session Expired",
        "Please log in again",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    handler.next(err);
  }
}