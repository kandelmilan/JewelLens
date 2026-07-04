import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/core/utils/app_size.dart';
import 'package:jewellens/core/assets/app_assets.dart';
import 'package:jewellens/features/auth/views/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();

  int currentIndex = 0;

  final List<Map<String, dynamic>> pages = [
    {
      "image": AppAssets.onboarding1,
      "title": "Discover Elegant Jewelry",
      "description":
          "Explore handcrafted collections of rings, necklaces, bracelets, and more.",
    },
    {
      "image": AppAssets.onboarding2,
      "title": "Certified Premium Quality",
      "description":
          "Every jewelry piece is carefully inspected and certified for authenticity.",
    },
    {
      "image": AppAssets.onboarding3,
      "title": "Fast & Secure Delivery",
      "description":
          "Enjoy safe packaging and quick delivery right to your doorstep.",
    },
  ];
  void nextPage() {
    if (currentIndex == pages.length - 1) {
      Get.offAll(() => const LoginView());
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.offAll(() => const LoginView());
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.screenPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "logo_onboarding",
                          child: Image.asset(
                            page["image"] as String,
                            height: 260,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const Gap(40),

                        Text(
                          page["title"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),

                        const Gap(16),

                        Text(
                          page["description"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const Gap(30),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.screenPadding),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: nextPage,
                  child: Text(
                    currentIndex == pages.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const Gap(30),
          ],
        ),
      ),
    );
  }
}
