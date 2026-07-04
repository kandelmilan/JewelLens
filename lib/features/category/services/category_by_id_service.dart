import 'package:jewellens/features/category/models/category_by_id_model.dart';
import 'package:jewellens/core/network/api_connect.dart';

class CategoryByIdService {
  Future<CategoryByIdModel> getCategoryById(int categoryId) async {
    try {
      final response = await ApiConnect.dio.get("categories/$categoryId");
      return CategoryByIdModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
