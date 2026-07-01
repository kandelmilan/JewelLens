import 'package:get/get.dart';
import 'package:jewellens/models/Home_Content/heroslider_model.dart';
import 'package:jewellens/services/Home_Content/heroslider_service.dart';

class HerosliderController extends GetxController {
  final HeroSliderService _service = HeroSliderService();

  final isLoading = false.obs;

  final heroSlider = HeroSliderModel(status: null, message: null, data: []).obs;

  @override
  void onInit() {
    super.onInit();
    fetchHeroSlider();
  }

  Future<void> fetchHeroSlider() async {
    try {
      isLoading.value = true;

      final response = await _service.getHeroSliders();

      heroSlider.value = response;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
