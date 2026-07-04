import 'package:flutter/material.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/features/home/widgets/brand_partner_widget.dart';
import 'package:jewellens/features/category/widgets/categories_widget.dart';
import 'package:jewellens/features/product/widgets/featured_products_widget.dart';
import 'package:jewellens/features/home/widgets/heroslider_widget.dart';
import 'package:jewellens/features/home/widgets/instagram_post_widget.dart';
import 'package:jewellens/features/home/widgets/list_occasions_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(.15),
              child: const Icon(
                Icons.diamond_outlined,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Morning 👋",
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Milan",
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
