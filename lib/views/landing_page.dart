import 'package:flutter/material.dart';
import 'package:jewellens/widgets/brand_partner_widget.dart';

import 'package:jewellens/widgets/heroslider_widget.dart';
import 'package:jewellens/widgets/instagram_post_widget.dart';
import 'package:jewellens/widgets/list_occasions_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

// // class _HomeViewState extends State<HomeView> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("JewelLens")),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             const SizedBox(height: 15),

// //             HeroSliderWidget(),

// //             const SizedBox(height: 20),
// //             BrandPartnerWidget(),
// //             const SizedBox(height: 20),
// //             InstagramPostWidget(),
// //             const SizedBox(height: 20),
// //             ListOccasionsWidget(),
// //             const SizedBox(height: 20),
// //             const Text("More sections coming..."),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:jewellens/widgets/brand_partner_widget.dart';
// import 'package:jewellens/widgets/heroslider_widget.dart';
// import 'package:jewellens/widgets/instagram_post_widget.dart';
// import 'package:jewellens/widgets/list_occasions_widget.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   static const Color _primary = Color(0xFF9C7C38);
//   static const Color _surface = Color(0xFFFAF7F2);
//   static const Color _textDark = Color(0xFF1F1B16);
//   static const Color _textMuted = Color(0xFF7A7168);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _surface,
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: _surface,
//         foregroundColor: _textDark,
//         title: const Text(
//           "JewelLens",
//           style: TextStyle(fontWeight: FontWeight.bold, color: _textDark),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Hero Slider
//               HeroSliderWidget(),

//               const SizedBox(height: 28),

//               /// Brand Partners
//               const SizedBox(height: 14),

//               BrandPartnerWidget(),

//               const SizedBox(height: 28),

//               /// Instagram
//               const SizedBox(height: 14),

//               InstagramPostWidget(),

//               const SizedBox(height: 28),

//               /// Occasions
//               const SizedBox(height: 14),

//               ListOccasionsWidget(),

//               const SizedBox(height: 40),

//               Center(
//                 child: Text(
//                   "More collections coming soon...",
//                   style: TextStyle(color: _textMuted, fontSize: 16),
//                 ),
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class _HomeViewState extends State<HomeView> {
  static const Color _primary = Color(0xFF9C7C38);
  static const Color _surface = Color(0xFFFAF7F2);
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _border = Color(0xFFE4DED2);

  int currentIndex = 0;

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

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 18,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,

          selectedItemColor: _primary,
          unselectedItemColor: _textMuted,

          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: "Categories",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: "Wishlist",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: "Cart",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    bool badge = false,
    required VoidCallback onTap,
  }) {
    return Stack(
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
              ),
              child: Icon(icon, color: _textDark),
            ),
          ),
        ),

        if (badge)
          Positioned(
            top: 9,
            right: 9,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
