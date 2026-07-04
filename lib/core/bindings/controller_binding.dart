import 'package:get/get.dart';
import 'package:jewellens/features/category/controllers/category_by_id_controller.dart';
import 'package:jewellens/features/home/controllers/brand_partner_controller.dart';
import 'package:jewellens/features/home/controllers/heroslider_controller.dart';
import 'package:jewellens/features/home/controllers/instagram_post_controller.dart';
import 'package:jewellens/features/home/controllers/list_occasions_controller.dart';
import 'package:jewellens/features/auth/controller/auth_controller.dart';
import 'package:jewellens/features/category/controllers/category_controller.dart';
import 'package:jewellens/features/home/models/list_occasions_model.dart';
import 'package:jewellens/features/profile/controller/profile_controller.dart';

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
    Get.put<ProfileController>(ProfileController(), permanent: true);
  }
}
