import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/models/Category/category_by_id_model.dart';
import 'package:jewellens/services/Category/category_by_id_service.dart';

class CategoryByIdController extends GetxController {
  final CategoryByIdService _service = CategoryByIdService();
  final isLoading = false.obs;
  final categoryById = CategoryByIdModel(
    status: null,
    message: null,
    data: null,
  ).obs;

  Future<void> fetchCategoryById(int id) async {
    try {
      isLoading.value = true;

      final response = await _service.getCategoryById(id);

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
