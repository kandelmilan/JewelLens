import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/Category/category_by_id_controller.dart';
import 'package:jewellens/controllers/Category/category_by_slug_controller.dart';

class CategoryDetailView extends StatefulWidget {
  final int? categoryId;
  final String? slug;

  const CategoryDetailView({super.key, this.categoryId, this.slug})
    : assert(
        categoryId != null || slug != null,
        "Either categoryId or slug must be provided",
      );

  @override
  State<CategoryDetailView> createState() => _CategoryDetailViewState();
}

class _CategoryDetailViewState extends State<CategoryDetailView> {
  static const Color _primary = Color(0xFF9C7C38);
  static const Color _surface = Color(0xFFFAF7F2);
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _border = Color(0xFFE4DED2);

  late final bool _useSlug;
  CategoryByIdController? _byIdController;
  CategoryBySlugController? _bySlugController;

  String get _tag => widget.slug ?? widget.categoryId.toString();

  @override
  void initState() {
    super.initState();
    _useSlug = widget.slug != null;

    if (_useSlug) {
      _bySlugController = Get.put(CategoryBySlugController(), tag: _tag);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _bySlugController!.fetchCategoryBySlug(widget.slug!);
      });
    } else {
      _byIdController = Get.put(CategoryByIdController(), tag: _tag);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _byIdController!.fetchCategoryById(widget.categoryId!);
      });
    }
  }

  @override
  void dispose() {
    if (_useSlug) {
      Get.delete<CategoryBySlugController>(tag: _tag);
    } else {
      Get.delete<CategoryByIdController>(tag: _tag);
    }
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
        title: const Text(
          "Category",
          style: TextStyle(color: _textDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        final isLoading = _useSlug
            ? _bySlugController!.isLoading.value
            : _byIdController!.isLoading.value;

        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: _primary),
          );
        }

        // Both controllers expose the same property name: categoryById
        final data = _useSlug
            ? _bySlugController!.categoryById.value.data
            : _byIdController!.categoryById.value.data;

        if (data == null) {
          return const Center(
            child: Text(
              "Category not found",
              style: TextStyle(color: _textMuted),
            ),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: _primary.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: data.icon != null && data.icon!.isNotEmpty
                      ? Image.network(
                          data.icon!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.diamond_outlined,
                            color: _primary,
                            size: 50,
                          ),
                        )
                      : const Icon(
                          Icons.diamond_outlined,
                          color: _primary,
                          size: 50,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                data.name ?? "",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.slug ?? "",
                style: const TextStyle(fontSize: 14, color: _textMuted),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Status", data.status ?? "-"),
                    const Divider(height: 20, color: _border),
                    _infoRow(
                      "Created",
                      data.createdAt != null
                          ? "${data.createdAt!.day}/${data.createdAt!.month}/${data.createdAt!.year}"
                          : "-",
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: _textMuted, fontSize: 13)),
        Text(
          value,
          style: const TextStyle(
            color: _textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
