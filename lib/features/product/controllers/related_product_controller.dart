import 'package:get/get.dart';
import 'package:jewellens/features/product/models/related_product_model.dart';
import 'package:jewellens/features/product/repositories/product_repository.dart';
import 'package:jewellens/features/product/services/related_product_service.dart';

class RelatedProductController extends GetxController {
  final ProductRepository _productRepository;

  RelatedProductController({ProductRepository? productRepository})
    : _productRepository = productRepository ?? ProductRepositoryImpl();
  final isLoading = false.obs;
  final product = RelatedProductModel(
    status: null,
    message: null,
    data: [],
  ).obs;

  Future<void> fetchRelatedProduct(String pSlug) async {
    try {
      isLoading.value = true;
      final response = await _productRepository.getRelatedProduct(pSlug);
      product.value = response;
    } catch (e) {
      Get.snackbar("Error", "Error in RelatedProduct :${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
