import 'package:jewellens/features/category/models/categories_by_slug_model.dart';
import 'package:jewellens/features/category/models/category_by_id_model.dart';
import 'package:jewellens/core/network/api_connect.dart';

class CategoryBySlugService {
  Future<CategoryBySlugModel> getCategoryBySlug(String slug) async {
    try {
      final response = await ApiConnect.dio.get("categories/$slug");
      return CategoryBySlugModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
