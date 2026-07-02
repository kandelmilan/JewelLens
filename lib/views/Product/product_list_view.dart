import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/Product/products_controller.dart';
import 'package:jewellens/views/Product/product_detailed_view.dart';

class ProductListView extends StatefulWidget {
  final String? categorySlug;
  final String? title;

  const ProductListView({super.key, this.categorySlug, this.title});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  static const Color _primary = Color(0xFF9C7C38);
  static const Color _surface = Color(0xFFFAF7F2);
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _border = Color(0xFFE4DED2);

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
      backgroundColor: _surface,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: _textDark),
        title: Text(
          widget.title ?? "Products",
          style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _primary),
          );
        }

        final list = controller.products.value.data;

        if (list.isEmpty) {
          return const Center(
            child: Text(
              "No products found",
              style: TextStyle(color: _textMuted),
            ),
          );
        }

        return RefreshIndicator(
          color: _primary,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailView(slug: item.slug!),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _border),
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
                                  color: _primary.withOpacity(.08),
                                  child: const Icon(
                                    Icons.diamond_outlined,
                                    color: _primary,
                                  ),
                                ),
                              )
                            : Container(
                                height: 140,
                                color: _primary.withOpacity(.08),
                                child: const Icon(
                                  Icons.diamond_outlined,
                                  color: _primary,
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
                                color: _textDark,
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
                                    color: _primary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                if (item.originalPrice != null &&
                                    item.originalPrice != item.price)
                                  Text(
                                    "₹${item.originalPrice}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: _textMuted,
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
