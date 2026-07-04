import 'package:jewellens/features/category/models/categories_model.dart';
import 'package:jewellens/core/network/api_connect.dart';

class CategoriesService {
  Future<CategoriesModel> getCategories() async {
    try {
      final response = await ApiConnect.dio.get("categories");

      return CategoriesModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
