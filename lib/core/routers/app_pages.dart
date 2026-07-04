import 'package:get/get.dart';
import 'package:jewellens/core/routers/app_routes.dart';
import 'package:jewellens/features/auth/views/login_view.dart';
import 'package:jewellens/features/auth/views/register_view.dart';
import 'package:jewellens/features/category/views/%20category_detail_view.dart';
import 'package:jewellens/features/home/views/landing_page.dart';
import 'package:jewellens/features/main_nav/main_nav_view.dart';
import 'package:jewellens/features/onboarding/onboarding_view.dart';
import 'package:jewellens/features/splash/splash_view.dart';
import 'package:jewellens/features/category/views/categories_view.dart';
import 'package:jewellens/features/product/views/product_detailed_view.dart';
import 'package:jewellens/features/product/views/product_list_view.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingView()),
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.register, page: () => const RegisterView()),
    GetPage(name: AppRoutes.landing, page: () => const HomeView()),
    GetPage(name: AppRoutes.mainNav, page: () => const MainNavView()),

    GetPage(name: AppRoutes.categories, page: () => const CategoriesView()),

    GetPage(
      name: AppRoutes.categoryDetail,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return CategoryDetailView(
          categoryId: args['categoryId'] as int?,
          slug: args['slug'] as String?,
        );
      },
    ),

    GetPage(
      name: AppRoutes.products,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return ProductListView(
          categorySlug: args['categorySlug'] as String?,
          title: args['title'] as String?,
        );
      },
    ),

    GetPage(
      name: AppRoutes.productDetail,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return ProductDetailView(
          slug: args['slug'] as String?,
          productId: args['productId'] as String?,
        );
      },
    ),
  ];
}
