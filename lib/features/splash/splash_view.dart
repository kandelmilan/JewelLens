import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/services/inactivity/inactivity_service.dart';
import 'package:jewellens/services/storages/token_storage.dart';
import 'package:jewellens/core/assets/app_assets.dart';
import 'package:jewellens/features/main_nav/main_nav_view.dart';
import 'package:jewellens/features/onboarding/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Run the timer and token check in parallel so you don't wait 2s + lookup time
    final results = await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      TokenStorage.instance.hasToken(),
    ]);

    final bool isLoggedIn = results[1] as bool;

    if (!mounted) return;

    if (isLoggedIn) {
      if (isLoggedIn) {
        InactivityService.instance.startWatching();
        Get.off(() => const MainNavView());
      }
      Get.off(() => const MainNavView());
    } else {
      Get.off(() => const OnboardingView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Luxury You Can Wear",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 60),

            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
