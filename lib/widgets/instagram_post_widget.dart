import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/Home_Content/instagram_post_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class InstagramPostWidget extends StatelessWidget {
  InstagramPostWidget({super.key});

  final InstagramPostController controller = Get.put(InstagramPostController());

  // Luxury Theme Colors (Same as Login Screen)
  static const Color _primary = Color(0xFF9C7C38);
  static const Color _surface = Color(0xFFFAF7F2);
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _borderLight = Color(0xFFE4DED2);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 250,
          child: Center(child: CircularProgressIndicator(color: _primary)),
        );
      }

      if (controller.instagramPosts.value.data.isEmpty) {
        return const SizedBox(
          height: 180,
          child: Center(
            child: Text(
              "No Instagram Posts",
              style: TextStyle(
                color: _textDark,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Heading
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Follow us on Instagram",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Latest jewellery inspirations & styling ideas",
                  style: TextStyle(color: _textMuted, fontSize: 15),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 285,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 18),
              itemCount: controller.instagramPosts.value.data.length,
              itemBuilder: (context, index) {
                final post = controller.instagramPosts.value.data[index];

                return GestureDetector(
                  onTap: () async {
                    if (post.link != null && post.link!.isNotEmpty) {
                      await launchUrl(
                        Uri.parse(post.link!),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: _borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        /// Image
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: post.image ?? "",
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => const Center(
                                    child: CircularProgressIndicator(
                                      color: _primary,
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    color: Colors.white,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        color: _primary,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /// Instagram Badge
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 18,
                                    color: _primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Content
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.caption ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _textDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${post.likes ?? 0}",
                                    style: const TextStyle(
                                      color: _textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const Spacer(),

                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: _primary,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(0, 36),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (post.link != null &&
                                          post.link!.isNotEmpty) {
                                        await launchUrl(
                                          Uri.parse(post.link!),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "View",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
