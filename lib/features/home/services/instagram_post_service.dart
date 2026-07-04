import 'package:jewellens/features/home/models/instagram_post_model.dart';

import 'package:jewellens/core/network/api_connect.dart';

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