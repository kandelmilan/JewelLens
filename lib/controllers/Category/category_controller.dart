import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jewellens/models/Category/categories_model.dart';
import 'package:jewellens/services/Category/categories_service.dart';

class CategoryController extends GetxController {
  final CategoriesService _service = CategoriesService();

  final isLoading = false.obs;

  final category = CategoriesModel(status: null, message: null, data: []).obs;

  Future<void> fetchCategory() async {
    try {
      isLoading.value = true;

      final response = await _service.getCategories();

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
