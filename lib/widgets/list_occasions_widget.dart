import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/Home_Content/list_occasions_controller.dart';

class ListOccasionsWidget extends StatelessWidget {
  ListOccasionsWidget({super.key});

  final ListOccasionsController controller = Get.put(ListOccasionsController());

  // Luxury Theme Colors
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
          height: 260,
          child: Center(child: CircularProgressIndicator(color: _primary)),
        );
      }

      if (controller.occasions.value.data.isEmpty) {
        return const SizedBox();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Heading
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Shop by Occasion",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Find jewellery perfect for every celebration.",
                  style: TextStyle(color: _textMuted, fontSize: 15),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 265,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              separatorBuilder: (_, __) => const SizedBox(width: 18),
              itemCount: controller.occasions.value.data.length,
              itemBuilder: (context, index) {
                final occasion = controller.occasions.value.data[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    // Navigate using occasion.link
                  },
                  child: Container(
                    width: 190,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Occasion Image
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: occasion.image ?? "",
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
                        ),

                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: _borderLight),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: CachedNetworkImage(
                                    imageUrl: occasion.icon ?? "",
                                    placeholder: (_, __) =>
                                        const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: _primary,
                                        ),
                                    errorWidget: (_, __, ___) => const Icon(
                                      Icons.category_outlined,
                                      color: _primary,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  occasion.name ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _textDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                // Navigate using occasion.link
                              },
                              child: const Text(
                                "Explore",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
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
