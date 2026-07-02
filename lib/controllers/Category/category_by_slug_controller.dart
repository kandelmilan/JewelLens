import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/models/Category/category_by_id_model.dart';
import 'package:jewellens/services/Category/category_by_slug_service.dart';

class CategoryBySlugController extends GetxController {
  final CategoryBySlugService _service = CategoryBySlugService();
  final isLoading = false.obs;
  final categoryById = CategoryByIdModel(
    status: null,
    message: null,
    data: null,
  ).obs;

  Future<void> fetchCategoryBySlug(String slug) async {
    try {
      isLoading.value = true;

      final response = await _service.getCategoryBySlug(slug);

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
