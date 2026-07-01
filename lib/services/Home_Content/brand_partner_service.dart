import 'package:jewellens/models/Home_Content/brand_partner_model.dart';

import 'package:jewellens/utils/api_connect.dart';

class BrandPartnerService {
  Future<BrandPartnerModel> getBrandPartners() async {
    try {
      final response = await ApiConnect.dio.get("brand-partners");

      return BrandPartnerModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}