class BrandPartnerModel {
    BrandPartnerModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final int? status;
    final String? message;
    final List<Datum> data;

    factory BrandPartnerModel.fromJson(Map<String, dynamic> json){ 
        return BrandPartnerModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

}

class Datum {
    Datum({
        required this.id,
        required this.name,
        required this.logo,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    final String? id;
    final String? name;
    final String? logo;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            id: json["_id"],
            name: json["name"],
            logo: json["logo"],
            status: json["status"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            v: json["__v"],
        );
    }

}
