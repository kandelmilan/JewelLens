import 'package:get/get.dart';
import 'package:jewellens/models/Home_Content/instagram_post_model.dart';
import 'package:jewellens/services/Home_Content/instagram_post_service.dart';

class InstagramPostController extends GetxController {
  final InstagramPostService _service = InstagramPostService();

  final isLoading = false.obs;

  final instagramPosts = InstagramPostModel(
    status: 0,
    message: "",
    data: [],
  ).obs;

  @override
  void onInit() {
    super.onInit();
    fetchInstagramPosts();
  }

  Future<void> fetchInstagramPosts() async {
    try {
      isLoading.value = true;

      final response = await _service.getInstagramPosts();

      instagramPosts.value = response;
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
