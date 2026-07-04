import 'package:jewellens/features/auth/models/login_model.dart';
import 'package:jewellens/features/auth/models/register_model.dart';
import 'package:jewellens/features/auth/services/auth_service.dart';

/// Contract the Controller depends on. Controller never imports AuthService
/// directly — only this interface. This is what makes the Controller
/// mockable/testable later without touching Dio at all.
abstract class AuthRepository {
  Future<LoginModel> login(String email, String password, bool remember);

  Future<RegisterModel> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    String phone,
    String address,
    bool terms,
  );
}

/// Real implementation — talks to AuthService (Dio calls) today.
/// If offline/cache support is ever needed for auth, this is the ONLY
/// file that changes — AuthController stays untouched.
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<LoginModel> login(String email, String password, bool remember) {
    return AuthService.login(email, password, remember);
  }

  @override
  Future<RegisterModel> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    String phone,
    String address,
    bool terms,
  ) {
    return AuthService.register(
      name,
      email,
      password,
      confirmPassword,
      phone,
      address,
      terms,
    );
  }
}