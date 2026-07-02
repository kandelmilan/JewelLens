import 'package:get/get.dart';
import 'package:jewellens/controllers/Category/category_by_id_controller.dart';
import 'package:jewellens/controllers/Home_Content/brand_partner_controller.dart';
import 'package:jewellens/controllers/Home_Content/heroslider_controller.dart';
import 'package:jewellens/controllers/Home_Content/instagram_post_controller.dart';
import 'package:jewellens/controllers/Home_Content/list_occasions_controller.dart';
import 'package:jewellens/controllers/auth_controller.dart';
import 'package:jewellens/controllers/Category/category_controller.dart';
import 'package:jewellens/models/Home_Content/list_occasions_model.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<HerosliderController>(HerosliderController(), permanent: true);
    Get.put<InstagramPostController>(
      InstagramPostController(),
      permanent: true,
    );
    Get.put<ListOccasionsController>(
      ListOccasionsController(),
      permanent: true,
    );
    Get.put<BrandPartnerController>(BrandPartnerController(), permanent: true);
    Get.put<CategoryController>(CategoryController(), permanent: true);
  }
}
