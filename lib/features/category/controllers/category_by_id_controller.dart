import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jewellens/features/category/models/category_by_id_model.dart';
import 'package:jewellens/features/category/repositories/category_repository.dart';

class CategoryByIdController extends GetxController {
  final CategoryRepository _categoryRepository;

  CategoryByIdController({CategoryRepository? categoryRepository})
    : _categoryRepository = categoryRepository ?? CategoryRepositoryImpl();

  final isLoading = false.obs;
  final categoryById = CategoryByIdModel(
    status: null,
    message: null,
    data: null,
  ).obs;

  Future<void> fetchCategoryById(int id) async {
    try {
      isLoading.value = true;

      final response = await _categoryRepository.getCategoryById(id);

      categoryById.value = response;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", e.toString());
      });
    } finally {
      isLoading.value = false;
    }
  }
}