import 'package:dio/dio.dart';
import 'package:requests_inspector/requests_inspector.dart';

class ApiConnect {
  static Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://backend-jewellens.onrender.com/api/",
      headers: {"Accept": "application/json"},
    ),
  )..interceptors.addAll([RequestsInspectorInterceptor()]);
}
