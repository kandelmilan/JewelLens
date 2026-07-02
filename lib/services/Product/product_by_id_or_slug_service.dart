
import 'package:jewellens/models/Product/product_by_id_or_slug_model.dart';
import 'package:jewellens/utils/api_connect.dart';

class ProductByIdOrSlugService {
  Future<ProductByIdOrSlugModel> getProductBySlug(String slug) async {
    try {
      final response = await ApiConnect.dio.get("products/$slug");
      return ProductByIdOrSlugModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductByIdOrSlugModel> getProductById(String id) async {
    try {
      final response = await ApiConnect.dio.get("products/id/$id");
      return ProductByIdOrSlugModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}