import 'package:flutter/material.dart';
import 'package:jewellens/widgets/brand_partner_widget.dart';
import 'package:jewellens/widgets/categories_widget.dart';
import 'package:jewellens/widgets/featured_products_widget.dart';
import 'package:jewellens/widgets/heroslider_widget.dart';
import 'package:jewellens/widgets/instagram_post_widget.dart';
import 'package:jewellens/widgets/list_occasions_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const Color _primary = Color(0xFF9C7C38);
  static const Color _surface = Color(0xFFFAF7F2);
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _border = Color(0xFFE4DED2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,

      appBar: AppBar(
        toolbarHeight: 82,
        backgroundColor: _surface,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _primary.withOpacity(.15),
              child: const Icon(Icons.diamond_outlined, color: _primary),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Morning 👋",
                    style: TextStyle(fontSize: 13, color: _textMuted),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Milan",
                    style: TextStyle(
                      fontSize: 22,
                      color: _textDark,
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
                border: Border.all(color: _border),
              ),
              child: IconButton(
                icon: const Icon(Icons.search),
                color: _textDark,
                onPressed: () {},
              ),
            ),

            const SizedBox(width: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    color: _textDark,
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
