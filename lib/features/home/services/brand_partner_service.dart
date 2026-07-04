import 'package:jewellens/features/home/models/brand_partner_model.dart';

import 'package:jewellens/core/network/api_connect.dart';

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