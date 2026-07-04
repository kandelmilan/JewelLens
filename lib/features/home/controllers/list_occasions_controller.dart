import 'package:get/get.dart';
import 'package:jewellens/features/home/models/list_occasions_model.dart';
import 'package:jewellens/features/home/services/list_occasions_service.dart';

class ListOccasionsController extends GetxController {
  final isLoading = false.obs;

  final occasions = ListOccasions(
    status: null,
    message: null,
    data: [],
  ).obs;

  final ListOccasionsService _service = ListOccasionsService();

  Future<void> fetchOccasions() async {
    try {
      isLoading.value = true;

      final response = await _service.getOccasions();

      occasions.value = response;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchOccasions();
  }
}