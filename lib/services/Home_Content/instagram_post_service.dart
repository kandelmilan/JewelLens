import 'package:jewellens/models/Home_Content/instagram_post_model.dart';

import 'package:jewellens/utils/api_connect.dart';

class InstagramPostService {
  Future<InstagramPostModel> getInstagramPosts() async {
    try {
      final response = await ApiConnect.dio.get("instagram-posts");

      return InstagramPostModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}