import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/features/home/widgets/brand_partner_widget.dart';
import 'package:jewellens/features/category/widgets/categories_widget.dart';
import 'package:jewellens/features/product/widgets/featured_products_widget.dart';
import 'package:jewellens/features/home/widgets/heroslider_widget.dart';
import 'package:jewellens/features/home/widgets/instagram_post_widget.dart';
import 'package:jewellens/features/home/widgets/list_occasions_widget.dart';
import 'package:jewellens/features/profile/controllers/user_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final UserController userController = Get.find<UserController>();

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      appBar: AppBar(
        toolbarHeight: 82,
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            Obx(() {
              final profile = userController.user.value?.data;

              return CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(.15),
                backgroundImage:
                    profile?.avatar != null && profile!.avatar!.isNotEmpty
                    ? NetworkImage(profile.avatar!)
                    : null,
                child:
                    profile == null ||
                        profile.avatar == null ||
                        profile.avatar!.isEmpty
                    ? const Icon(Icons.person, color: AppColors.primary)
                    : null,
              );
            }),
            const SizedBox(width: 14),
            Expanded(
              child: Obx(() {
                final profile = userController.user.value?.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${getGreeting()} 👋",
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile?.name ?? "Guest",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: IconButton(
                icon: const Icon(Icons.search),
                color: AppColors.textDark,
                onPressed: () {},
              ),
            ),

            const SizedBox(width: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    color: AppColors.textDark,
                    onPressed: () {},
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: [
              HeroSliderWidget(),
              const SizedBox(height: 28),
              CategoriesWidget(),
              const SizedBox(height: 20),
              FeaturedProductsWidget(),
              const SizedBox(height: 20),
              BrandPartnerWidget(),
              const SizedBox(height: 28),
              InstagramPostWidget(),
              const SizedBox(height: 28),
              ListOccasionsWidget(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
