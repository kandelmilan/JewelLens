import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:jewellens/bindings/controller_binding.dart';
import 'package:jewellens/views/auth_view/login_view.dart';
import 'package:jewellens/views/auth_view/register_view.dart';
import 'package:jewellens/views/landing_page.dart';
import 'package:jewellens/views/onboarding/onboarding_view.dart';
import 'package:jewellens/views/splash/splash_view.dart';
import 'package:requests_inspector/requests_inspector.dart';

void main() {
  runApp(RequestsInspector(enabled: true, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialBinding: ControllerBinding(),
      home: const HomeView(),
    );
  }
}
