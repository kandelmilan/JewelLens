import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/utils/assets/app_assets.dart';
import 'package:jewellens/views/onboarding/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  static const Color primary = Color(0xFF9C7C38);
  static const Color background = Color(0xFFFAF7F2);

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Get.off(() => const OnboardingView());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.appLogo, width: 160),

            const SizedBox(height: 24),

            const Text(
              "Jewellens",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primary,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Luxury You Can Wear",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 60),

            const CircularProgressIndicator(color: primary),
          ],
        ),
      ),
    );
  }
}
