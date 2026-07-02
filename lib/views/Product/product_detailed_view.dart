import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/Product/product_by_id_or_slug_controller.dart';

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
  static const Color _primary = Color(0xFF9C7C38);
  static const Color _surface = Color(0xFFFAF7F2);
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _border = Color(0xFFE4DED2);

  late final ProductByIdOrSlugController controller;
  String get _tag => widget.slug ?? widget.productId!;
  int _selectedImage = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductByIdOrSlugController(), tag: _tag);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.slug != null) {
        controller.fetchBySlug(widget.slug!);
      } else {
        controller.fetchById(widget.productId!);
      }
    });
  }

  @override
  void dispose() {
    Get.delete<ProductByIdOrSlugController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _primary),
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
                  style: TextStyle(color: _textMuted),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Go back",
                    style: TextStyle(color: _primary),
                  ),
                ),
              ],
            ),
          );
        }

        final item = list;
        final discount =
            (item.originalPrice != null &&
                item.price != null &&
                item.originalPrice! > item.price!)
            ? (((item.originalPrice! - item.price!) / item.originalPrice!) *
                      100)
                  .round()
            : null;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: _surface,
              elevation: 0,
              pinned: true,
              expandedHeight: 360,
              iconTheme: const IconThemeData(color: _textDark),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    item.images.isNotEmpty
                        ? Image.network(
                            item.images[_selectedImage],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: _primary.withOpacity(.08),
                              child: const Icon(
                                Icons.diamond_outlined,
                                color: _primary,
                                size: 60,
                              ),
                            ),
                          )
                        : Container(
                            color: _primary.withOpacity(.08),
                            child: const Icon(
                              Icons.diamond_outlined,
                              color: _primary,
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
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.offerBadge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
                                  color: active ? _primary : Colors.white,
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
                    icon: const Icon(Icons.favorite_border, color: _textDark),
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
                          color: _primary,
                          letterSpacing: .5,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      item.name ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
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
                                color: _primary,
                                size: 18,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "(${item.reviews ?? 0} reviews)",
                            style: const TextStyle(
                              fontSize: 12,
                              color: _textMuted,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.price != null ? "₹${item.price}" : "",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: _primary,
                          ),
                        ),
                        if (item.originalPrice != null &&
                            item.originalPrice != item.price) ...[
                          const SizedBox(width: 10),
                          Text(
                            "₹${item.originalPrice}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: _textMuted,
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
                    const Divider(color: _border),
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
                      ...item.variants.map((variant) {
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
                                  color: _textDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: variant.options.map((opt) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: _border),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      opt.value ?? "",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: _textDark,
                                      ),
                                    ),
                                  );
                                }).toList(),
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
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description!,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: _textMuted,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    if (item.specifications != null) ...[
                      const Text(
                        "Specifications",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _border),
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
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.craftsmanshipStory!,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: _textMuted,
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
                          color: _textDark,
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
                                color: _textDark,
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
                                      color: _textMuted,
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
                        color: _surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _border),
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
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
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
          ),
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
          color: _primary.withOpacity(.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: _primary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                color: _primary,
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
          Icon(icon, size: 18, color: _primary),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: _textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12.5, color: _textMuted),
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
                style: const TextStyle(fontSize: 12.5, color: _textMuted),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                e.value!,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: _textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
