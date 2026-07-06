import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/core/routers/app_routes.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/features/cart/controllers/cart_controllers.dart';
import 'package:jewellens/features/cart/models/cart_model.dart' as cart_models;
import 'package:jewellens/features/category/controllers/category_controller.dart';
import 'package:jewellens/features/product/controllers/products_controller.dart';

/// ---------------------------------------------------------------------
/// REUSABLE CONTENT — search bar + category chips + product grid.
/// No Scaffold / AppBar here, so it can be dropped into ANY page
/// (HomeView, ProductListView, a "Shop by category" tab, etc.)
/// without creating nested Scaffolds.
/// ---------------------------------------------------------------------
class ProductGridSection extends StatefulWidget {
  final String? categorySlug;
  final String tag;
  final bool showSearchBar;
  final bool showCategoryFilter;
  final EdgeInsets padding;

  const ProductGridSection({
    super.key,
    this.categorySlug,
    required this.tag,
    this.showSearchBar = true,
    this.showCategoryFilter = true,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  State<ProductGridSection> createState() => _ProductGridSectionState();
}

class _ProductGridSectionState extends State<ProductGridSection> {
  late final ProductsController controller;
  CategoryController? categoryController;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String? _selectedCategorySlug;

  @override
  void initState() {
    super.initState();
    _selectedCategorySlug = widget.categorySlug;

    controller = Get.put(ProductsController(), tag: widget.tag);

    if (widget.showCategoryFilter) {
      categoryController = Get.put(
        CategoryController(),
        tag: "${widget.tag}_categories",
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProducts(categorySlug: _selectedCategorySlug);
      categoryController?.fetchCategory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    Get.delete<ProductsController>(tag: widget.tag);
    if (widget.showCategoryFilter) {
      Get.delete<CategoryController>(tag: "${widget.tag}_categories ");
    }
    super.dispose();
  }

  void _onCategoryTap(String? slug) {
    setState(() => _selectedCategorySlug = slug);
    controller.fetchProducts(categorySlug: slug);
  }

  /// Matches on whole words, not raw substrings.
  /// Naive `.contains("ring")` also matches "earrings" (which literally
  /// contains the letters r-i-n-g), so instead we split the product name
  /// into words and require each query word to be the START of some word
  /// in the name. "ring" -> matches "Ring", "Rings", "Ring Set"
  ///                      -> does NOT match "Earrings", "Boring pattern"
  /// "diamond ring" -> matches "Diamond Ring Set" (both query words hit)
  bool _matchesSearch(String name, String query) {
    final nameWords = name.toLowerCase().trim().split(RegExp(r'\s+'));
    final queryWords = query.toLowerCase().trim().split(RegExp(r'\s+'));

    return queryWords.every(
      (qWord) => nameWords.any((nWord) => nWord.startsWith(qWord)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showSearchBar)
          Padding(
            padding: EdgeInsets.fromLTRB(
              widget.padding.left,
              widget.padding.top,
              widget.padding.right,
              12,
            ),
            child: _SearchField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = "");
              },
            ),
          ),

        if (widget.showCategoryFilter)
          SizedBox(
            height: 40,
            child: Obx(() {
              final categories = categoryController?.category.value.data ?? [];
              return ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: widget.padding.left),
                children: [
                  _CategoryChip(
                    label: "All ",
                    selected: _selectedCategorySlug == null,
                    onTap: () => _onCategoryTap(null),
                  ),
                  const SizedBox(width: 8),
                  ...categories.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _CategoryChip(
                        label: c.name ?? "",
                        selected: _selectedCategorySlug == c.slug,
                        onTap: () => _onCategoryTap(c.slug),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),

        if (widget.showCategoryFilter) const SizedBox(height: 14),

        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final all = controller.products.value.data;
            final list = _searchQuery.isEmpty
                ? all
                : all
                      .where((p) => _matchesSearch(p.name ?? "", _searchQuery))
                      .toList();

            if (list.isEmpty) {
              return Center(
                child: Text(
                  _searchQuery.isEmpty
                      ? "No products found"
                      : "No results for \"$_searchQuery\"",
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () =>
                  controller.fetchProducts(categorySlug: _selectedCategorySlug),
              child: GridView.builder(
                padding: EdgeInsets.fromLTRB(
                  widget.padding.left,
                  0,
                  widget.padding.right,
                  widget.padding.bottom,
                ),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.62,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) =>
                    _ProductCard(item: list[index]),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: "Search rings, necklaces, earrings...",
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textMuted,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                onPressed: onClear,
              );
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final dynamic item; // your Product model

  const _ProductCard({required this.item});

  CartController get _cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  bool get _hasVariants {
    try {
      return (item.variants as List).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _handleAddToCart(BuildContext context) {
    if (item.inStock == false) {
      Get.snackbar('Out of Stock', 'This item is currently unavailable.');
      return;
    }

    // Variants (size/color/etc.) need an explicit choice — can't guess
    // one here, so send the user to the detail page to pick instead.
    if (_hasVariants) {
      Get.toNamed(AppRoutes.productDetail, arguments: {'slug': item.slug});
      return;
    }

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

    _cartController.addToCart(
      cart_models.CartItem(
        product: product,
        quantity: 1,
        selectedVariants: const [],
      ),
    );

    Get.snackbar(
      'Added to Bag',
      '${item.name ?? 'Item'} has been added to your bag.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount =
        item.originalPrice != null && item.originalPrice != item.price;
    final int? discountPercent = hasDiscount && item.originalPrice > 0
        ? (((item.originalPrice - item.price) / item.originalPrice) * 100)
              .round()
        : null;
    final bool outOfStock = item.inStock == false;

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.productDetail, arguments: {'slug': item.slug});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: item.images.isNotEmpty
                        ? Image.network(
                            item.images.first,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: AppColors.primary.withOpacity(.06),
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primary.withOpacity(.08),
                              child: const Icon(
                                Icons.diamond_outlined,
                                color: AppColors.primary,
                                size: 32,
                              ),
                            ),
                          )
                        : Container(
                            color: AppColors.primary.withOpacity(.08),
                            child: const Icon(
                              Icons.diamond_outlined,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                  ),
                  if (discountPercent != null && discountPercent > 0)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "-$discountPercent%",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  if (outOfStock)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(.45),
                        alignment: Alignment.center,
                        child: const Text(
                          "Out of Stock",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.06),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.favorite_border_rounded,
                          size: 16,
                          color: AppColors.textDark,
                        ),
                        onPressed: () {
                          // TODO: wire up to your wishlist controller
                        },
                      ),
                    ),
                  ),
                  // Quick "Add to Cart" action, bottom-right of the image.
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Material(
                      color: outOfStock
                          ? Colors.grey.shade300
                          : AppColors.primary,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: outOfStock
                            ? null
                            : () => _handleAddToCart(context),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Icon(
                            _hasVariants
                                ? Icons.chevron_right_rounded
                                : Icons.add_shopping_cart_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        item.price != null ? "₹${item.price}" : "",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (hasDiscount)
                        Flexible(
                          child: Text(
                            "₹${item.originalPrice}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough,
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
  }
}

/// ---------------------------------------------------------------------
/// FULL-SCREEN WRAPPER — used for:
///  1) routing from a category tap (Get.toNamed with {'slug': ...})
///  2) the "Products" tab in MainNavView's bottom nav (no arguments)
/// ---------------------------------------------------------------------
class ProductListView extends StatelessWidget {
  final String? categorySlug;
  final String? title;

  const ProductListView({super.key, this.categorySlug, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: Text(
          title ?? "Products",
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ProductGridSection(
          categorySlug: categorySlug,
          tag: categorySlug ?? "all_products",
        ),
      ),
    );
  }
}
