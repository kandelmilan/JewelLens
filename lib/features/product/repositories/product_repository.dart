import 'package:jewellens/features/product/models/products_model.dart';
import 'package:jewellens/features/product/models/product_by_id_or_slug_model.dart';
import 'package:jewellens/features/product/models/related_product_model.dart';
import 'package:jewellens/features/product/services/products_service.dart';
import 'package:jewellens/features/product/services/product_by_id_or_slug_service.dart';
import 'package:jewellens/features/product/services/related_product_service.dart';

/// One Repository per FEATURE (product), not one per Service.
/// Even though there are 3 services behind this, Controllers only ever
/// see this single interface — they don't know or care how many services
/// exist underneath, or which one answers which method.
abstract class ProductRepository {
  Future<ProductsModel> getProducts({String? categorySlug, bool? featured});
  Future<ProductByIdOrSlugModel> getProductBySlug(String slug);
  Future<ProductByIdOrSlugModel> getProductById(String id);
  Future<RelatedProductModel> getRelatedProduct(String productSlug);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductsService _productsService;
  final ProductByIdOrSlugService _productByIdOrSlugService;
  final RelatedProductService _relatedProductService;

  // Each service defaults to a real instance, but can be swapped out in
  // tests — e.g. ProductRepositoryImpl(productsService: FakeProductsService())
  ProductRepositoryImpl({
    ProductsService? productsService,
    ProductByIdOrSlugService? productByIdOrSlugService,
    RelatedProductService? relatedProductService,
  }) : _productsService = productsService ?? ProductsService(),
       _productByIdOrSlugService =
           productByIdOrSlugService ?? ProductByIdOrSlugService(),
       _relatedProductService =
           relatedProductService ?? RelatedProductService();

  @override
  Future<ProductsModel> getProducts({String? categorySlug, bool? featured}) {
    return _productsService.getProducts(
      categorySlug: categorySlug,
      featured: featured,
    );
  }

  @override
  Future<ProductByIdOrSlugModel> getProductBySlug(String slug) {
    return _productByIdOrSlugService.getProductBySlug(slug);
  }

  @override
  Future<ProductByIdOrSlugModel> getProductById(String id) {
    return _productByIdOrSlugService.getProductById(id);
  }

  @override
  Future<RelatedProductModel> getRelatedProduct(String productSlug) {
    return _relatedProductService.getRelatedProduct(productSlug);
  }
}
