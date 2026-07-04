import 'package:dio/dio.dart';
import 'package:jewellens/features/product/models/products_model.dart';
import 'package:jewellens/services/storages/token_storage.dart';
import 'package:jewellens/core/network/api_connect.dart';

class ProductsService {
  Future<ProductsModel> getProducts({
    String? categorySlug,
    bool? featured,
  }) async {
    try {
      final Map<String, dynamic> query = {};
      if (categorySlug != null) query["category"] = categorySlug;
      if (featured != null) query["featured"] = featured;
      // final token = await TokenStorage.instance.getAccessToke();
      final response = await ApiConnect.dio.get(
        "products",
        queryParameters: query.isEmpty ? null : query,
        // options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return ProductsModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
