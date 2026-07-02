import 'package:jewellens/models/Product/products_model.dart';
import 'package:jewellens/utils/api_connect.dart';

class ProductsService {
  Future<ProductsModel> getProducts({
    String? categorySlug,
    bool? featured,
  }) async {
    try {
      final Map<String, dynamic> query = {};
      if (categorySlug != null) query["category"] = categorySlug;
      if (featured != null) query["featured"] = featured;

      final response = await ApiConnect.dio.get(
        "products",
        queryParameters: query.isEmpty ? null : query,
      );

      return ProductsModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
