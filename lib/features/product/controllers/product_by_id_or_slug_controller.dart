import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/features/product/models/product_by_id_or_slug_model.dart';
import 'package:jewellens/features/product/repositories/product_repository.dart';
import 'package:jewellens/features/product/services/product_by_id_or_slug_service.dart';

class ProductByIdOrSlugController extends GetxController {
  // final ProductByIdOrSlugService _service = ProductByIdOrSlugService();
  final ProductRepository _productRepository;

  ProductByIdOrSlugController({ProductRepository? productRespository})
    : _productRepository = productRespository ?? ProductRepositoryImpl();

  final isLoading = false.obs;
  final product = ProductByIdOrSlugModel(
    status: null,
    message: null,
    data: null,
  ).obs;

  Future<void> fetchBySlug(String slug) async {
    try {
      isLoading.value = true;
      final response = await _productRepository.getProductBySlug(slug);
      product.value = response;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", e.toString());
      });
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchById(String id) async {
    try {
      isLoading.value = true;
      final response = await _productRepository.getProductById(id);
      product.value = response;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", e.toString());
      });
    } finally {
      isLoading.value = false;
    }
  }
}
