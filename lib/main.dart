import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:jewellens/core/bindings/controller_binding.dart';
import 'package:jewellens/core/routers/app_pages.dart';
import 'package:jewellens/core/routers/app_routes.dart';
import 'package:jewellens/core/theme/app_theme.dart';
import 'package:jewellens/services/inactivity/inactivity_service.dart';
import 'package:jewellens/features/auth/views/login_view.dart';
import 'package:jewellens/features/auth/views/register_view.dart';
import 'package:jewellens/features/home/views/landing_page.dart';
import 'package:jewellens/features/main_nav/main_nav_view.dart';
import 'package:jewellens/features/onboarding/onboarding_view.dart';
import 'package:jewellens/features/splash/splash_view.dart';
import 'package:requests_inspector/requests_inspector.dart';

void main() {
  Get.put(InactivityService());

  runApp(RequestsInspector(enabled: true, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jewellens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      initialBinding: ControllerBinding(),
      getPages: AppPages.pages,
      builder: (context, child) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) =>
              InactivityService.instance.registerInteraction(),
          onPointerMove: (_) =>
              InactivityService.instance.registerInteraction(),
          child: child,
        );
      },
    );
  }
}
