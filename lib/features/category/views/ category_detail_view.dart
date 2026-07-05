import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/features/category/controllers/category_by_id_controller.dart';
import 'package:jewellens/features/category/controllers/category_by_slug_controller.dart';

/// Small internal DTO so the view only ever deals with ONE shape of data,
/// regardless of whether it came from the "by id" or "by slug" endpoint.
class _CategoryViewData {
  final String? name;
  final String? slug;
  final String? icon;
  final String? status;
  final DateTime? createdAt;

  const _CategoryViewData({
    this.name,
    this.slug,
    this.icon,
    this.status,
    this.createdAt,
  });
}

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
    } else {
      _byIdController = Get.put(CategoryByIdController(), tag: _tag);
    }
    _fetch();
  }

  void _fetch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_useSlug) {
        _bySlugController!.fetchCategoryBySlug(widget.slug!);
      } else {
        _byIdController!.fetchCategoryById(widget.categoryId!);
      }
    });
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

  bool get _isLoading => _useSlug
      ? _bySlugController!.isLoading.value
      : _byIdController!.isLoading.value;

  /// Single place where the "which controller?" branching happens.
  /// Everything below this only ever touches [_CategoryViewData].
  _CategoryViewData? get _data {
    if (_useSlug) {
      final d = _bySlugController!.categoryBySlug.value.data;
      if (d == null) return null;
      return _CategoryViewData(
        name: d.name,
        slug: d.slug,
        icon: d.icon,
        status: d.status,
        createdAt: d.createdAt,
      );
    } else {
      final d = _byIdController!.categoryById.value.data;
      if (d == null) return null;
      return _CategoryViewData(
        name: d.name,
        slug: d.slug,
        icon: d.icon,
        status: d.status,
        createdAt: d.createdAt,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Text(
          "Category",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (_isLoading) {
          return const _DetailSkeleton();
        }

        final data = _data;
        if (data == null) {
          return _EmptyState(onRetry: _fetch);
        }

        final isActive = (data.status ?? "").toLowerCase() == "active";

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => _fetch(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              children: [
                _CategoryAvatar(icon: data.icon),
                const SizedBox(height: 20),
                Text(
                  data.name ?? "Untitled category",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                if (data.slug != null && data.slug!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data.slug!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.03),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(
                        "Status",
                        valueWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? AppColors.success
                                    : AppColors.textMuted,
                              ),
                            ),
                            Text(
                              data.status ?? "-",
                              style: TextStyle(
                                color: isActive
                                    ? AppColors.success
                                    : AppColors.textDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 24, color: AppColors.border),
                      _infoRow(
                        "Created",
                        value: data.createdAt != null
                            ? "${data.createdAt!.day.toString().padLeft(2, '0')}/"
                                  "${data.createdAt!.month.toString().padLeft(2, '0')}/"
                                  "${data.createdAt!.year}"
                            : "-",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _infoRow(String label, {String? value, Widget? valueWidget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        valueWidget ??
            Text(
              value ?? "-",
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
      ],
    );
  }
}

class _CategoryAvatar extends StatelessWidget {
  final String? icon;
  const _CategoryAvatar({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.10),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withOpacity(.15),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: (icon != null && icon!.isNotEmpty)
            ? Image.network(
                icon!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.diamond_outlined,
                  color: AppColors.primary,
                  size: 50,
                ),
              )
            : const Icon(
                Icons.diamond_outlined,
                color: AppColors.primary,
                size: 50,
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.textMuted.withOpacity(.6),
            ),
            const SizedBox(height: 12),
            const Text(
              "Category not found",
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "It may have been removed or the link is incorrect.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Try again"),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget bar({double width = double.infinity, double height = 14}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
              color: AppColors.border,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 20),
          bar(width: 160, height: 18),
          const SizedBox(height: 10),
          bar(width: 90, height: 20),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [bar(width: 60), bar(width: 60)],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [bar(width: 60), bar(width: 80)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
