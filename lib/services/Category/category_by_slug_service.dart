import 'package:jewellens/models/Category/category_by_id_model.dart';
import 'package:jewellens/utils/api_connect.dart';

class CategoryBySlugService {
  Future<CategoryByIdModel> getCategoryBySlug(String slug) async {
    try {
      final response = await ApiConnect.dio.get("categories/$slug");
      return CategoryByIdModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
