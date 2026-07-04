import 'package:jewellens/features/home/models/list_occasions_model.dart';
import 'package:jewellens/core/network/api_connect.dart';

class ListOccasionsService {
  Future<ListOccasions> getOccasions() async {
    try {
      final response = await ApiConnect.dio.get("occasions");

      return ListOccasions.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
