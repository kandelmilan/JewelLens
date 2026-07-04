import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/features/product/models/products_model.dart';
import 'package:jewellens/features/product/repositories/product_repository.dart';
import 'package:jewellens/features/product/services/products_service.dart';

class ProductsController extends GetxController {
  // final ProductsService _service = ProductsService();
  final ProductRepository _productRepository;

  ProductsController({ProductRepository? ProductRepository})
    : _productRepository = ProductRepository ?? ProductRepositoryImpl();

  final isLoading = false.obs;
  final products = ProductsModel(status: null, message: null, data: []).obs;

  Future<void> fetchProducts({String? categorySlug, bool? featured}) async {
    try {
      isLoading.value = true;

      final response = await _productRepository.getProducts(
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
