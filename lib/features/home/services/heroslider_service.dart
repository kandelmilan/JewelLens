import 'package:jewellens/features/home/models/heroslider_model.dart';
import 'package:jewellens/core/network/api_connect.dart';

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
