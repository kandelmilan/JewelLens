import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/features/category/controllers/category_controller.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
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
                  color: AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: navigate to full CategoriesView page
                },
                child: const Text(
                  "See all",
                  style: TextStyle(
                    color: AppColors.primary,
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
              return const _CategoriesSkeleton(border: AppColors.border);
            }

            final list = controller.category.value.data;

            if (list.isEmpty) {
              return const Center(
                child: Text(
                  "No categories found",
                  style: TextStyle(color: AppColors.textMuted),
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
                            border: Border.all(color: AppColors.border),
                          ),
                          child: ClipOval(
                            child: item.icon != null && item.icon!.isNotEmpty
                                ? Image.network(
                                    item.icon!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.diamond_outlined,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : const Icon(
                                    Icons.diamond_outlined,
                                    color: AppColors.primary,
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
                            color: AppColors.textDark,
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

/// Shimmering skeleton shown while categories are loading.
class _CategoriesSkeleton extends StatefulWidget {
  final Color border;
  const _CategoriesSkeleton({required this.border});

  @override
  State<_CategoriesSkeleton> createState() => _CategoriesSkeletonState();
}

class _CategoriesSkeletonState extends State<_CategoriesSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final opacity = 0.4 + 0.3 * (0.5 - (_controller.value - 0.5).abs());
            return SizedBox(
              width: 72,
              child: Column(
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(opacity),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(opacity),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
