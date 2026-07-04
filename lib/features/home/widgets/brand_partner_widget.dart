import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/features/home/controllers/brand_partner_controller.dart';

class BrandPartnerWidget extends StatelessWidget {
  BrandPartnerWidget({super.key});

  final BrandPartnerController controller = Get.put(BrandPartnerController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Our Brand Partners",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const SizedBox(
              height: 90,
              child: _BrandPartnerSkeleton(border: AppColors.border),
            ),
          ],
        );
      }

      if (controller.brandPartners.value.data.isEmpty) {
        return const Center(child: Text("No Brand Partners Found"));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Our Brand Partners",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 15),

          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.brandPartners.value.data.length,
              separatorBuilder: (_, __) => const SizedBox(width: 15),
              itemBuilder: (context, index) {
                final brand = controller.brandPartners.value.data[index];

                return Container(
                  width: 90,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: brand.logo ?? "",
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.primary,
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

/// Shimmering skeleton shown while brand partners are loading.
class _BrandPartnerSkeleton extends StatefulWidget {
  final Color border;
  const _BrandPartnerSkeleton({required this.border});

  @override
  State<_BrandPartnerSkeleton> createState() => _BrandPartnerSkeletonState();
}

class _BrandPartnerSkeletonState extends State<_BrandPartnerSkeleton>
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(width: 15),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final opacity = 0.4 + 0.3 * (0.5 - (_controller.value - 0.5).abs());
            return Container(
              width: 90,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: widget.border),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(opacity),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
