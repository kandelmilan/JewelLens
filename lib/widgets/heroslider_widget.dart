// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jewellens/controllers/Home_Content/heroslider_controller.dart';

// class HeroSliderWidget extends StatelessWidget {
//   HeroSliderWidget({super.key});

//   final HerosliderController controller = Get.put(HerosliderController());

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const SizedBox(
//           height: 220,
//           child: Center(child: CircularProgressIndicator()),
//         );
//       }

//       if (controller.heroSlider.value.data.isEmpty) {
//         return const SizedBox(
//           height: 220,
//           child: Center(child: Text("No Hero Slider Available")),
//         );
//       }

//       return CarouselSlider.builder(
//         itemCount: controller.heroSlider.value.data.length,
//         itemBuilder: (context, index, realIndex) {
//           final item = controller.heroSlider.value.data[index];

//           return ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 CachedNetworkImage(
//                   imageUrl: item.image ?? "",
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) =>
//                       const Center(child: CircularProgressIndicator()),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),

//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.center,
//                       colors: [
//                         Colors.black.withOpacity(.65),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                 ),

//                 Positioned(
//                   left: 20,
//                   right: 20,
//                   bottom: 20,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.title ?? "",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         item.subtitle ?? "",
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//         options: CarouselOptions(
//           height: 220,
//           autoPlay: true,
//           enlargeCenterPage: true,
//           viewportFraction: 0.92,
//           autoPlayInterval: const Duration(seconds: 4),
//         ),
//       );
//     });
//   }
// }

// // another design

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/Home_Content/heroslider_controller.dart';

class HeroSliderWidget extends StatelessWidget {
  HeroSliderWidget({super.key});

  final HerosliderController controller = Get.put(HerosliderController());

  // Luxury Theme
  static const Color _primary = Color(0xFF9C7C38);
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _surface = Color(0xFFFAF7F2);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 240,
          child: Center(child: CircularProgressIndicator(color: _primary)),
        );
      }

      if (controller.heroSlider.value.data.isEmpty) {
        return const SizedBox(
          height: 240,
          child: Center(
            child: Text(
              "No Hero Slider Available",
              style: TextStyle(color: _textDark, fontSize: 16),
            ),
          ),
        );
      }

      return CarouselSlider.builder(
        itemCount: controller.heroSlider.value.data.length,
        itemBuilder: (context, index, realIndex) {
          final item = controller.heroSlider.value.data[index];

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: item.image ?? "",
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(color: _primary),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: _primary,
                        size: 40,
                      ),
                    ),
                  ),

                  /// Premium Gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromARGB(220, 0, 0, 0),
                          Color.fromARGB(80, 0, 0, 0),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  /// Content
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          item.subtitle ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 18),

                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Explore Collection",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 250,
          viewportFraction: .92,
          enlargeCenterPage: true,
          enlargeFactor: .18,
          autoPlay: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.easeInOut,
          autoPlayInterval: const Duration(seconds: 4),
        ),
      );
    });
  }
}
