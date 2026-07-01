import 'package:jewellens/models/Home_Content/heroslider_model.dart';
import 'package:jewellens/utils/api_connect.dart';

class HeroSliderService {
  Future<HeroSliderModel> getHeroSliders() async {
    try {
      final response = await ApiConnect.dio.get("hero-sliders");

      return HeroSliderModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
