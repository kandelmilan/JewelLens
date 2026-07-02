import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/Category/category_controller.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  static const Color _primary = Color(0xFF9C7C38);
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _border = Color(0xFFE4DED2);

  final CategoryController controller = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    controller.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Shop by Category",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: navigate to full CategoriesView page
                },
                child: const Text(
                  "See all",
                  style: TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: _primary),
              );
            }

            final list = controller.category.value.data;

            if (list.isEmpty) {
              return const Center(
                child: Text(
                  "No categories found",
                  style: TextStyle(color: _textMuted),
                ),
              );
            }

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final item = list[index];
                return GestureDetector(
                  onTap: () {
                    // TODO: navigate to product listing filtered by item.slug
                  },
                  child: SizedBox(
                    width: 72,
                    child: Column(
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: _border),
                          ),
                          child: ClipOval(
                            child: item.icon != null && item.icon!.isNotEmpty
                                ? Image.network(
                                    item.icon!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.diamond_outlined,
                                      color: _primary,
                                    ),
                                  )
                                : const Icon(
                                    Icons.diamond_outlined,
                                    color: _primary,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
