class CategoriesModel {
    CategoriesModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final int? status;
    final String? message;
    final List<Datum> data;

    factory CategoriesModel.fromJson(Map<String, dynamic> json){ 
        return CategoriesModel(
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
        required this.slug,
        required this.icon,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    final String? id;
    final String? name;
    final String? slug;
    final String? icon;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            id: json["_id"],
            name: json["name"],
            slug: json["slug"],
            icon: json["icon"],
            status: json["status"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            v: json["__v"],
        );
    }

}
