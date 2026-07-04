import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jewellens/features/category/models/categories_model.dart';
import 'package:jewellens/features/category/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _categoryRepository;

  CategoryController({CategoryRepository? categoryRepository})
    : _categoryRepository = categoryRepository ?? CategoryRepositoryImpl();

  final isLoading = false.obs;

  final category = CategoriesModel(status: null, message: null, data: []).obs;

  Future<void> fetchCategory() async {
    try {
      isLoading.value = true;

      final response = await _categoryRepository.getCategories();

      category.value = response;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", e.toString());
      });
    } finally {
      isLoading.value = false;
    }
  }
}
