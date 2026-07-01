import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/auth_controller.dart';
import 'package:jewellens/utils/app_size.dart';
import 'package:jewellens/utils/assets/app_assets.dart';
import 'package:jewellens/views/auth_view/register_view.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  // Local color tokens — adjust these to match your brand
  static const Color _primary = Color(0xFF9C7C38); // muted gold
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _borderLight = Color(0xFFE4DED2);
  static const Color _surface = Color(0xFFFAF7F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSize.screenPadding),
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// APP ICON
                    Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        margin: const EdgeInsets.only(top: 8, bottom: 4),
                        child: Image.asset(
                          AppAssets.appLogo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint("App icon failed to load: $error");
                            return Icon(
                              Icons.diamond_outlined,
                              color: _primary,
                              size: 36,
                            );
                          },
                        ),
                      ),
                    ),

                    Gap(AppSize.vGap * 1.2),

                    Text(
                      "Sign in to your Account",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: _textDark,
                          ),
                    ),

                    const Gap(8),

                    Text(
                      "Enter your email and password to log in",
                      style: TextStyle(color: _textMuted, fontSize: 16),
                    ),

                    Gap(AppSize.vGap),

                    // /// EMAIL
                    TextFormField(
                      controller: controller.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }

                        if (!GetUtils.isEmail(value.trim())) {
                          return "Please enter a valid email";
                        }

                        return null;
                      },
                      style: TextStyle(color: _textDark),
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your Email",
                        labelStyle: TextStyle(color: _textMuted),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: _borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: _primary, width: 1.5),
                        ),
                      ),
                    ),

                    Gap(AppSize.vGap),

                    /// PASSWORD
                    Obx(() {
                      return TextFormField(
                        controller: controller.password,
                        obscureText: controller.obscure.value,
                        style: TextStyle(color: _textDark),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }

                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your Password",
                          labelStyle: TextStyle(color: _textMuted),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            onPressed: controller.togglePassword,
                            icon: Icon(
                              controller.obscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: _textMuted,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: _borderLight),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: _primary, width: 1.5),
                          ),
                        ),
                      );
                    }),

                    Gap(AppSize.vGap),

                    /// REMEMBER + FORGOT PASSWORD
                    Obx(
                      () => Row(
                        children: [
                          GestureDetector(
                            onTap: () => controller.remember.value =
                                !controller.remember.value,
                            child: Icon(
                              controller.remember.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: controller.remember.value
                                  ? _primary
                                  : _textMuted,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Remember me",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: _textDark),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              // Get.toNamed(AppRoutes.forgotPassword);
                            },
                            child: Text(
                              "Forget Password?",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(AppSize.vGap * 1.2),

                    /// LOGIN BUTTON (LOADING STATE)
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: _primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  if (!controller.loginFormKey.currentState!
                                      .validate()) {
                                    return;
                                  }

                                  await controller.login();

                                  controller.email.clear();
                                  controller.password.clear();
                                  controller.loginFormKey.currentState?.reset();
                                },
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ),

                    Gap(AppSize.vGap),

                    Row(
                      children: [
                        Expanded(child: Divider(color: _borderLight)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "or",
                            style: TextStyle(color: _textMuted),
                          ),
                        ),
                        Expanded(child: Divider(color: _borderLight)),
                      ],
                    ),

                    Gap(AppSize.vGap),

                    /// GOOGLE
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _borderLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          // controller.loginWithGoogle();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.googleImg,
                              height: 22,
                              width: 22,
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint(
                                  "Google image failed to load: $error",
                                );
                                return const Icon(Icons.g_mobiledata, size: 24);
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Continue with Google",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(color: _textDark),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(AppSize.vGap),

                    /// APPLE
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _borderLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          // controller.loginWithApple();
                        },
                        icon: Icon(Icons.apple, size: 24, color: _textDark),
                        label: Text(
                          "Continue with Apple",
                          style: TextStyle(color: _textDark),
                        ),
                      ),
                    ),

                    Gap(AppSize.vGap * 1.5),

                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: _textMuted),
                            ),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: _primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.off(() => const RegisterView());
                                },
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(AppSize.vGap),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
