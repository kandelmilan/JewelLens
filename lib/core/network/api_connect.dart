import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jewellens/core/network/auth_interceptor.dart';
import 'package:jewellens/core/network/inspector_interceptor.dart';

class ApiConnect {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://backend-jewellens.onrender.com/api/",
      headers: {"Accept": "application/json"},
      connectTimeout: const Duration(
        seconds: 15,
      ), // time to establish connection
      receiveTimeout: const Duration(
        seconds: 45,
      ), // time to wait for full response
      sendTimeout: const Duration(seconds: 15),
    ),
  )..interceptors.addAll([AuthInterceptor(), ...buildInspectorInterceptors()]);

  //to warm up the server
  static Future<void> warmUpServer() async {
    try {
      await dio.get(
        "health",
        options: Options(receiveTimeout: const Duration(seconds: 50)),
      );
      debugPrint("Server is warm ");
    } catch (e) {
      debugPrint("Warm-up ping failed (server may still be waking): $e");
    }
  }
}
