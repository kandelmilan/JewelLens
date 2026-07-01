import 'package:get/get.dart';
import 'package:jewellens/models/Home_Content/brand_partner_model.dart';

import 'package:jewellens/services/Home_Content/brand_partner_service.dart';

class BrandPartnerController extends GetxController {
  final BrandPartnerService _service = BrandPartnerService();

  final isLoading = false.obs;

  final brandPartners = BrandPartnerModel(status: 0, message: "", data: []).obs;

  @override
  void onInit() {
    super.onInit();
    fetchBrandPartners();
  }

  Future<void> fetchBrandPartners() async {
    try {
      isLoading.value = true;

      final response = await _service.getBrandPartners();

      brandPartners.value = response;
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
