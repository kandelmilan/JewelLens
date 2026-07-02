import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/models/Product/products_model.dart';
import 'package:jewellens/services/Product/products_service.dart';

class ProductsController extends GetxController {
  final ProductsService _service = ProductsService();

  final isLoading = false.obs;
  final products = ProductsModel(status: null, message: null, data: []).obs;

  Future<void> fetchProducts({String? categorySlug, bool? featured}) async {
    try {
      isLoading.value = true;

      final response = await _service.getProducts(
        categorySlug: categorySlug,
        featured: featured,
      );

      products.value = response;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", e.toString());
      });
    } finally {
      isLoading.value = false;
    }
  }
}
