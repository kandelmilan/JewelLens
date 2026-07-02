import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/Product/products_controller.dart';
import 'package:jewellens/views/Product/product_detailed_view.dart';
import 'package:jewellens/views/Product/product_list_view.dart';

class FeaturedProductsWidget extends StatefulWidget {
  const FeaturedProductsWidget({super.key});

  @override
  State<FeaturedProductsWidget> createState() => _FeaturedProductsWidgetState();
}

class _FeaturedProductsWidgetState extends State<FeaturedProductsWidget> {
  static const Color _primary = Color(0xFF9C7C38);
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _border = Color(0xFFE4DED2);

  final ProductsController controller = Get.put(
    ProductsController(),
    tag: "featured",
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProducts(featured: true);
    });
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
                "Featured Products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductListView()),
                  );
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
          height: 230,
          child: Obx(() {
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

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
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
                    width: 150,
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
                                  height: 130,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 130,
                                    color: _primary.withOpacity(.08),
                                    child: const Icon(
                                      Icons.diamond_outlined,
                                      color: _primary,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 130,
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
                              const SizedBox(height: 4),
                              Text(
                                item.price != null ? "₹${item.price}" : "",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _primary,
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
            );
          }),
        ),
      ],
    );
  }
}
