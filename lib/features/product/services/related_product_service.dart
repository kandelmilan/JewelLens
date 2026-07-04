import 'package:jewellens/features/product/models/related_product_model.dart';
import 'package:jewellens/core/network/api_connect.dart';

class RelatedProductService {
  Future<RelatedProductModel> getRelatedProduct(String productSlug) async {
    final response = await ApiConnect.dio.get("products/related/$productSlug");
    return RelatedProductModel.fromJson(response.data);
  }
}
