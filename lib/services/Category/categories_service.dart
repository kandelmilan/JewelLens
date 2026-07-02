import 'package:jewellens/models/Category/categories_model.dart';
import 'package:jewellens/utils/api_connect.dart';

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
