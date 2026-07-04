import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/features/product/controllers/products_controller.dart';
import 'package:jewellens/features/product/views/product_detailed_view.dart';
import 'package:jewellens/features/product/views/product_list_view.dart';

class FeaturedProductsWidget extends StatefulWidget {
  const FeaturedProductsWidget({super.key});

  @override
  State<FeaturedProductsWidget> createState() => _FeaturedProductsWidgetState();
}

class _FeaturedProductsWidgetState extends State<FeaturedProductsWidget> {
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

  String _formatPrice(num price) {
    final str = price.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromEnd = str.length - i;
      buffer.write(str[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
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
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  letterSpacing: 0.2,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductListView()),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "See all",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: Obx(() {
            if (controller.isLoading.value) {
              return _FeaturedListSkeleton(border: AppColors.border);
            }

            final list = controller.products.value.data;

            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.diamond_outlined,
                      color: AppColors.textMuted.withOpacity(.4),
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "No products found",
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
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
                return _ProductCard(
                  name: item.name ?? "",
                  price: item.price,
                  imageUrl: item.images.isNotEmpty ? item.images.first : null,
                  primary: AppColors.primary,
                  primaryLight: AppColors.primaryLight,
                  textDark: AppColors.textDark,
                  border: AppColors.background,
                  formatPrice: _formatPrice,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailView(slug: item.slug!),
                      ),
                    );
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class _ProductCard extends StatefulWidget {
  final String name;
  final num? price;
  final num? originalPrice; // optional: pass if you track discounts
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final Color primary;
  final Color primaryLight;
  final Color textDark;
  final Color border;
  final String Function(num) formatPrice;
  final VoidCallback onTap;

  const _ProductCard({
    required this.name,
    required this.price,
    this.originalPrice,
    this.rating,
    this.reviewCount,
    required this.imageUrl,
    required this.primary,
    required this.primaryLight,
    required this.textDark,
    required this.border,
    required this.formatPrice,
    required this.onTap,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _pressed = false;
  bool _favorited = false;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        widget.originalPrice != null &&
        widget.price != null &&
        widget.originalPrice! > widget.price!;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: 155,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.primary.withOpacity(.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with framed padding + gradient scrim + favorite button
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: widget.primaryLight),
                        if (widget.imageUrl != null)
                          Image.network(
                            widget.imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: widget.primary,
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(
                                Icons.diamond_outlined,
                                color: widget.primary,
                                size: 28,
                              ),
                            ),
                          )
                        else
                          Center(
                            child: Icon(
                              Icons.diamond_outlined,
                              color: widget.primary,
                              size: 28,
                            ),
                          ),

                        // subtle top gradient so the favorite icon stays legible
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 44,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(.18),
                                  Colors.black.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // discount badge
                        if (hasDiscount)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: widget.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "-${(((widget.originalPrice! - widget.price!) / widget.originalPrice!) * 100).round()}%",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                        // favorite button
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _favorited = !_favorited),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _favorited
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 15,
                                color: _favorited
                                    ? const Color(0xFFC0392B)
                                    : widget.textDark.withOpacity(.55),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(11, 10, 11, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if (widget.price != null)
                          Text(
                            "₹${widget.formatPrice(widget.price!)}",
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: widget.primary,
                            ),
                          ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            "₹${widget.formatPrice(widget.originalPrice!)}",
                            style: TextStyle(
                              fontSize: 11,
                              color: widget.textDark.withOpacity(.4),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // optional rating — shows only if you wire it up later
                    if (widget.rating != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 3),
                          Text(
                            widget.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: widget.textDark.withOpacity(.75),
                            ),
                          ),
                          if (widget.reviewCount != null) ...[
                            const SizedBox(width: 3),
                            Text(
                              "(${widget.reviewCount})",
                              style: TextStyle(
                                fontSize: 10.5,
                                color: widget.textDark.withOpacity(.4),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],

                    // always-visible add-to-bag button
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() => _added = true);
                        Future.delayed(const Duration(milliseconds: 1400), () {
                          if (mounted) setState(() => _added = false);
                        });
                        // TODO: hook this up to your cart controller, e.g.
                        // Get.find<CartController>().addToCart(item);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: _added
                              ? const Color(0xFF3E7B4F)
                              : widget.primary.withOpacity(.08),
                          borderRadius: BorderRadius.circular(8),
                          border: _added
                              ? null
                              : Border.all(
                                  color: widget.primary.withOpacity(.3),
                                ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _added
                                  ? Icons.check_rounded
                                  : Icons.add_shopping_cart_rounded,
                              size: 13,
                              color: _added ? Colors.white : widget.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _added ? "Added" : "Add to Bag",
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: _added ? Colors.white : widget.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmering skeleton shown while featured products are loading.
class _FeaturedListSkeleton extends StatefulWidget {
  final Color border;
  const _FeaturedListSkeleton({required this.border});

  @override
  State<_FeaturedListSkeleton> createState() => _FeaturedListSkeletonState();
}

class _FeaturedListSkeletonState extends State<_FeaturedListSkeleton>
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
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final opacity = 0.4 + 0.3 * (0.5 - (_controller.value - 0.5).abs());
            return Container(
              width: 155,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: widget.border.withOpacity(.7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(opacity),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(11, 10, 11, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(opacity),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 12,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(opacity),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 24,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(opacity),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
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
