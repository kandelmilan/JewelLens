import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/auth_controller.dart';
import 'package:jewellens/utils/app_size.dart';
import 'package:jewellens/utils/assets/app_assets.dart';
import 'package:jewellens/views/auth_view/login_view.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  // Local color tokens — match LoginView
  static const Color _primary = Color(0xFF9C7C38); // muted gold
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _borderLight = Color(0xFFE4DED2);
  static const Color _surface = Color(0xFFFAF7F2);

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: _textMuted),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
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
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          color: _textMuted,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

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
                key: controller.registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(AppSize.vGap * 1.5),

                    Text(
                      "Create your Account",
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
                      "Fill in your details to get started",
                      style: TextStyle(color: _textMuted, fontSize: 16),
                    ),

                    Gap(AppSize.vGap * 1.4),

                    /// SECTION: PERSONAL INFO
                    _sectionLabel("PERSONAL INFORMATION"),
                    const Gap(10),

                    /// NAME + PHONE (paired row)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: controller.name,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your full name";
                              }

                              if (value.trim().length < 3) {
                                return "Name is too short";
                              }

                              return null;
                            },
                            style: TextStyle(color: _textDark),
                            decoration: _fieldDecoration(
                              label: "Full Name",
                              hint: "Your name",
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: controller.phone,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your phone number";
                              }

                              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                return "Enter a valid 10-digit phone number";
                              }

                              return null;
                            },
                            style: TextStyle(color: _textDark),
                            decoration: _fieldDecoration(
                              label: "Phone",
                              hint: "98XXXXXXXX",
                            ),
                          ),
                        ),
                      ],
                    ),

                    Gap(AppSize.vGap),

                    /// EMAIL
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
                      decoration: _fieldDecoration(
                        label: "Email",
                        hint: "Enter your Email",
                      ),
                    ),

                    Gap(AppSize.vGap),

                    /// ADDRESS
                    TextFormField(
                      controller: controller.address,
                      keyboardType: TextInputType.streetAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your address";
                        }

                        return null;
                      },
                      style: TextStyle(color: _textDark),
                      decoration: _fieldDecoration(
                        label: "Address",
                        hint: "Enter your Address",
                      ),
                    ),

                    Gap(AppSize.vGap * 1.4),

                    /// SECTION: SECURITY
                    _sectionLabel("ACCOUNT SECURITY"),
                    const Gap(10),

                    /// PASSWORD
                    Obx(() {
                      return TextFormField(
                        controller: controller.password,
                        obscureText: controller.obscure.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a password";
                          }

                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }

                          return null;
                        },
                        style: TextStyle(color: _textDark),
                        decoration: _fieldDecoration(
                          label: "Password",
                          hint: "Enter your Password",
                          suffixIcon: IconButton(
                            onPressed: controller.togglePassword,
                            icon: Icon(
                              controller.obscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: _textMuted,
                            ),
                          ),
                        ),
                      );
                    }),

                    Gap(AppSize.vGap),

                    /// CONFIRM PASSWORD
                    Obx(() {
                      return TextFormField(
                        controller: controller.confirmPassword,
                        obscureText: controller.obscureConfirm.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          }

                          if (value != controller.password.text) {
                            return "Passwords do not match";
                          }

                          return null;
                        },
                        style: TextStyle(color: _textDark),
                        decoration: _fieldDecoration(
                          label: "Confirm Password",
                          hint: "Re-enter your Password",
                          suffixIcon: IconButton(
                            onPressed: controller.toggleConfirmPassword,
                            icon: Icon(
                              controller.obscureConfirm.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: _textMuted,
                            ),
                          ),
                        ),
                      );
                    }),

                    Gap(AppSize.vGap),

                    /// TERMS CHECKBOX
                    Obx(
                      () => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => controller.acceptTerms.value =
                                !controller.acceptTerms.value,
                            child: Icon(
                              controller.acceptTerms.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: controller.acceptTerms.value
                                  ? _primary
                                  : _textMuted,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "I agree to the ",
                                      style: TextStyle(color: _textDark),
                                    ),
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(
                                        color: _primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(AppSize.vGap * 1.2),

                    /// REGISTER BUTTON (LOADING STATE)
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
                                  if (!controller.registerFormKey.currentState!
                                      .validate()) {
                                    return;
                                  }

                                  if (!controller.acceptTerms.value) {
                                    Get.snackbar(
                                      "Terms & Conditions",
                                      "Please accept the Terms & Conditions",
                                    );
                                    return;
                                  }

                                  FocusScope.of(context).unfocus();

                                  await controller.register();

                                  controller.name.clear();
                                  controller.phone.clear();
                                  controller.email.clear();
                                  controller.address.clear();
                                  controller.password.clear();
                                  controller.confirmPassword.clear();

                                  controller.registerFormKey.currentState
                                      ?.reset();
                                  controller.acceptTerms.value = false;
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
                                  "Sign Up",
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
                              text: "Already have an account? ",
                              style: TextStyle(color: _textMuted),
                            ),
                            TextSpan(
                              text: "Sign In",
                              style: TextStyle(
                                color: _primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offAll(() => const LoginView());
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
