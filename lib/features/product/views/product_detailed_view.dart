import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/core/routers/app_routes.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/features/cart/controllers/cart_controllers.dart';
import 'package:jewellens/features/cart/models/cart_model.dart' as cart_models;
import 'package:jewellens/features/product/controllers/product_by_id_or_slug_controller.dart';
import 'package:jewellens/features/product/controllers/related_product_controller.dart';
import 'package:jewellens/features/product/models/related_product_model.dart'
    as related;
import 'package:jewellens/features/tryon/models/tryon_category.dart';
import 'package:jewellens/features/tryon/views/virtual_tryon_teaser.dart';

class ProductDetailView extends StatefulWidget {
  final String? slug;
  final String? productId;

  const ProductDetailView({super.key, this.slug, this.productId})
    : assert(
        slug != null || productId != null,
        "Either slug or productId must be provided",
      );

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final Map<int, dynamic> _selectedVariants = {};

  late final ProductByIdOrSlugController controller;
  late final RelatedProductController relatedController;
  String get _tag => widget.slug ?? widget.productId!;
  int _selectedImage = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductByIdOrSlugController(), tag: _tag);
    relatedController = Get.put(
      RelatedProductController(),
      tag: "related_$_tag",
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.slug != null) {
        controller.fetchBySlug(widget.slug!);
        relatedController.fetchRelatedProduct(widget.slug!);
      } else {
        controller.fetchById(widget.productId!);
      }
    });
  }

  @override
  void dispose() {
    Get.delete<ProductByIdOrSlugController>(tag: _tag);
    Get.delete<RelatedProductController>(tag: "related_$_tag");
    super.dispose();
  }

  TryOnCategory _inferCategory(String? categoryName) {
    final name = (categoryName ?? '').toLowerCase();
    if (name.contains('earring')) return TryOnCategory.earrings;
    if (name.contains('necklace') ||
        name.contains('chain') ||
        name.contains('pendant')) {
      return TryOnCategory.necklace;
    }
    if (name.contains('ring')) return TryOnCategory.ring;
    if (name.contains('bracelet') || name.contains('bangle')) {
      return TryOnCategory.bracelet;
    }
    return TryOnCategory.other;
  }

  /// Grabs the already-registered CartController if one exists (e.g. the
  /// bottom-nav's CartView already put one), otherwise creates it. Avoids
  /// resetting cart state just because this screen was opened.
  CartController get _cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  void _handleAddToCart(dynamic item) {
    if (item.inStock == false) {
      Get.snackbar('Out of Stock', 'This item is currently unavailable.');
      return;
    }

    // Require a choice for every variant group before adding.
    if (item.variants.isNotEmpty) {
      for (int i = 0; i < item.variants.length; i++) {
        if (!_selectedVariants.containsKey(i)) {
          final variant = item.variants[i];
          Get.snackbar(
            'Select an option',
            'Please choose ${variant.label ?? variant.type ?? 'an option'} before adding to cart.',
          );
          return;
        }
      }
    }

    final selectedVariants = <cart_models.SelectedVariant>[];
    _selectedVariants.forEach((index, option) {
      final variantType = item.variants[index].type as String?;
      selectedVariants.add(
        cart_models.SelectedVariant(type: variantType, value: option.value),
      );
    });

    final product = cart_models.Product.minimal(
      id: item.id ?? '',
      name: item.name,
      slug: item.slug,
      price: item.price,
      originalPrice: item.originalPrice,
      images: List<String>.from(item.images ?? const []),
      inStock: item.inStock,
      stockCount: item.stockCount,
      freeShipping: item.freeShipping,
      codAvailable: item.codAvailable,
      emiAvailable: item.emiAvailable,
      offerBadge: item.offerBadge,
      rating: item.rating,
      reviews: item.reviews,
    );

    final newItem = cart_models.CartItem(
      product: product,
      quantity: 1,
      selectedVariants: selectedVariants,
    );

    _cartController.addToCart(newItem);

    Get.snackbar(
      'Added to Bag',
      '${item.name ?? 'Item'} has been added to your bag.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final list = controller.product.value.data;

        if (list == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Product not found",
                  style: TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Go back",
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          );
        }

        final item = list;
        int totalAdjustment = 0;

        // Sum all selected variant price adjustments
        for (final option in _selectedVariants.values) {
          totalAdjustment += (option.priceAdjustment ?? 0) as int;
        }

        // Final displayed prices
        final currentPrice = (item.price ?? 0) + totalAdjustment;
        final originalPrice =
            (item.originalPrice ?? item.price ?? 0) + totalAdjustment;

        // Calculate discount
        final discount = originalPrice > currentPrice
            ? (((originalPrice - currentPrice) / originalPrice) * 100).round()
            : null;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              pinned: true,
              expandedHeight: 360,
              iconTheme: const IconThemeData(color: AppColors.textDark),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    item.images.isNotEmpty
                        ? Image.network(
                            item.images[_selectedImage],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primary.withOpacity(.08),
                              child: const Icon(
                                Icons.diamond_outlined,
                                color: AppColors.primary,
                                size: 60,
                              ),
                            ),
                          )
                        : Container(
                            color: AppColors.primary.withOpacity(.08),
                            child: const Icon(
                              Icons.diamond_outlined,
                              color: AppColors.primary,
                              size: 60,
                            ),
                          ),
                    if (item.offerBadge != null && item.offerBadge!.isNotEmpty)
                      Positioned(
                        top: 100,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.discount_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.offerBadge!.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (item.images.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(item.images.length, (i) {
                            final active = i == _selectedImage;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedImage = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                height: 8,
                                width: active ? 22 : 8,
                                decoration: BoxDecoration(
                                  color: active
                                      ? AppColors.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.15),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: AppColors.textDark,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                transform: Matrix4.translationValues(0, -20, 0),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.category?.name != null)
                      Text(
                        item.category!.name!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          letterSpacing: .5,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      item.name ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (item.rating != null)
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < item.rating!
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: AppColors.primary,
                                size: 18,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "(${item.reviews ?? 0} reviews)",
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹$currentPrice",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),

                        if (originalPrice != currentPrice) ...[
                          const SizedBox(width: 10),
                          Text(
                            "₹$originalPrice",
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        if (discount != null) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "$discount% OFF",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          item.inStock == true
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 15,
                          color: item.inStock == true
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.inStock == true
                              ? "In Stock${item.stockCount != null ? ' (${item.stockCount} left)' : ''}"
                              : "Out of Stock",
                          style: TextStyle(
                            fontSize: 12,
                            color: item.inStock == true
                                ? Colors.green.shade700
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        if (item.freeShipping == true)
                          _perkChip(
                            Icons.local_shipping_outlined,
                            "Free Shipping",
                          ),
                        if (item.codAvailable == true)
                          _perkChip(Icons.payments_outlined, "COD"),
                        if (item.emiAvailable == true)
                          _perkChip(Icons.credit_card, "EMI"),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (item.variants.isNotEmpty) ...[
                      ...item.variants.asMap().entries.map((entry) {
                        final index = entry.key;
                        final variant = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                variant.label ?? variant.type ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(
                                  variant.options.length,
                                  (optionIndex) {
                                    final opt = variant.options[optionIndex];
                                    final isSelected =
                                        _selectedVariants[index] == opt;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedVariants[index] = opt;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.border,
                                          ),
                                        ),
                                        child: Text(
                                          opt.value ?? "",
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    if (item.description != null) ...[
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description!,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Virtual Try-On ────────────────────────────────
                    // Fills the empty space between Description and
                    // Related Products with an interactive try-on card.
                    // VirtualTryOnTeaser(
                    //   productId: item.id ?? '',
                    //   productImage: item.images.isNotEmpty
                    //       ? item.images.first
                    //       : null,
                    //   productName: item.name,
                    //   category: _inferCategory(item.category?.name),
                    // ),
                    const SizedBox(height: 20),

                    // ──────────────────────────────────────────────────
                    const Text(
                      "Related Products",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Obx(() {
                      if (relatedController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final products = relatedController.product.value.data;

                      if (products.isEmpty) {
                        return const SizedBox();
                      }

                      return SizedBox(
                        height: 310,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (_, index) {
                            final product1 = products[index];

                            return _relatedProductCard(product1);
                          },
                        ),
                      );
                    }),

                    if (item.specifications != null) ...[
                      const Text(
                        "Specifications",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: _specRows(item.specifications!),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    if (item.craftsmanshipStory != null &&
                        item.craftsmanshipStory!.isNotEmpty) ...[
                      const Text(
                        "Craftsmanship",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.craftsmanshipStory!,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    if (item.faqs.isNotEmpty) ...[
                      const Text(
                        "FAQs",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...item.faqs.map(
                        (faq) => Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Text(
                              faq.question ?? "",
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    faq.answer ?? "",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.warranty != null)
                            _policyRow(
                              Icons.verified_outlined,
                              "Warranty",
                              item.warranty!,
                            ),
                          if (item.returnPolicy != null)
                            _policyRow(
                              Icons.replay_outlined,
                              "Returns",
                              item.returnPolicy!,
                            ),
                          if (item.estimatedDeliveryDays != null)
                            _policyRow(
                              Icons.local_shipping_outlined,
                              "Delivery",
                              "${item.estimatedDeliveryDays} days",
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Obx(() {
            final data = controller.product.value.data;
            final inStock = data?.inStock != false;

            return Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: (data == null || !inStock)
                        ? null
                        : () => _handleAddToCart(data),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: (data == null || !inStock)
                        ? null
                        : () {
                            _handleAddToCart(data);
                            // TODO: navigate straight to checkout for a
                            // true "Buy Now" flow instead of just adding.
                          },
                    child: const Text(
                      "Buy Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _perkChip(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: AppColors.primary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _policyRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _specRows(dynamic specs) {
    final map = <String, String?>{
      "Purity": specs.purity,
      "Style": specs.specificationsStyle ?? specs.style,
      "Occasion":
          specs.occasion ?? specs.occassion ?? specs.specificationsOccasion,
      "Finish": specs.finish,
      "Design": specs.design,
      "Comfort": specs.comfort,
      "Gold Purity": specs.goldPurity,
      "Type": specs.type,
      "Hallmark": specs.hallmark,
      "Material": specs.material,
      "Closure Type": specs.closureType,
    };

    final entries = map.entries
        .where((e) => e.value != null && e.value!.isNotEmpty)
        .toList();

    return entries.map((e) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                e.key,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                e.value!,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _relatedProductCard(related.Datum product) {
    final discount =
        (product.originalPrice != null &&
            product.price != null &&
            product.originalPrice! > product.price!)
        ? (((product.originalPrice! - product.price!) /
                      product.originalPrice!) *
                  100)
              .round()
        : null;

    return GestureDetector(
      onTap: () {
        // Get.toNamed(AppRoutes.productDetail, arguments: {'slug': product.slug});
        Get.off(() => ProductDetailView(slug: product.slug));
      },
      child: Container(
        width: 190,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: Image.network(
                      product.images.isNotEmpty ? product.images.first : "",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade100,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),

                if (discount != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$discount% OFF",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "${product.rating ?? 0}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${product.reviews ?? 0} Reviews",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "₹${product.price}",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (product.originalPrice != product.price)
                          Text(
                            "₹${product.originalPrice}",
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
