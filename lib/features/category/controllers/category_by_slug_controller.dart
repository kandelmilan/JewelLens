import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jewellens/features/category/models/categories_by_slug_model.dart';
import 'package:jewellens/features/category/repositories/category_repository.dart';

class CategoryBySlugController extends GetxController {
  final CategoryRepository _categoryRepository;

  CategoryBySlugController({CategoryRepository? categoryRepository})
    : _categoryRepository = categoryRepository ?? CategoryRepositoryImpl();

  final isLoading = false.obs;
  final categoryBySlug = CategoryBySlugModel(
    status: null,
    message: null,
    data: null,
  ).obs;

  Future<void> fetchCategoryBySlug(String slug) async {
    try {
      isLoading.value = true;

      final response = await _categoryRepository.getCategoryBySlug(slug);

      categoryBySlug.value = response;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", e.toString());
      });
    } finally {
      isLoading.value = false;
    }
  }
}
