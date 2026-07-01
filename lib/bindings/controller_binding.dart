import 'package:get/get.dart';
import 'package:jewellens/controllers/Home_Content/heroslider_controller.dart';
import 'package:jewellens/controllers/auth_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<HerosliderController>(HerosliderController(), permanent: true);
  }
}
