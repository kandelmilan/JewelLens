import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/core/routers/app_routes.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/features/product/controllers/products_controller.dart';
import 'package:jewellens/features/product/views/product_detailed_view.dart';

class ProductListView extends StatefulWidget {
  final String? categorySlug;
  final String? title;

  const ProductListView({super.key, this.categorySlug, this.title});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  late final ProductsController controller;
  String get _tag => widget.categorySlug ?? "all_products";

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductsController(), tag: _tag);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProducts(categorySlug: widget.categorySlug);
    });
  }

  @override
  void dispose() {
    Get.delete<ProductsController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: Text(
          widget.title ?? "Products",
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final list = controller.products.value.data;

        if (list.isEmpty) {
          return const Center(
            child: Text(
              "No products found",
              style: TextStyle(color: AppColors.textMuted),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () =>
              controller.fetchProducts(categorySlug: widget.categorySlug),
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.productDetail,
                    arguments: {'slug': item.slug},
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: item.images.isNotEmpty
                            ? Image.network(
                                item.images.first,
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 140,
                                  color: AppColors.primary.withOpacity(.08),
                                  child: const Icon(
                                    Icons.diamond_outlined,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : Container(
                                height: 140,
                                color: AppColors.primary.withOpacity(.08),
                                child: const Icon(
                                  Icons.diamond_outlined,
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  item.price != null ? "₹${item.price}" : "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                if (item.originalPrice != null &&
                                    item.originalPrice != item.price)
                                  Text(
                                    "₹${item.originalPrice}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                      decoration: TextDecoration.lineThrough,
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
        );
      }),
    );
  }
}
