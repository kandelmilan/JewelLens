import 'package:jewellens/features/auth/models/register_model.dart';
import 'package:jewellens/core/network/api_connect.dart';
import 'package:jewellens/features/auth/models/login_model.dart';

class AuthService {
  // login
  static Future<LoginModel> login(
    String email,
    String password,
    bool remember,
  ) async {
    try {
      final response = await ApiConnect.dio.post(
        "auth/login",
        data: {"email": email, "password": password, "remember": remember},
      );
      return LoginModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<RegisterModel> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    String phone,
    String address,
    bool terms,
  ) async {
    try {
      final response = await ApiConnect.dio.post(
        "auth/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "terms": terms,
          "phone": phone,
          "address": address,
        },
      );
      return RegisterModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
