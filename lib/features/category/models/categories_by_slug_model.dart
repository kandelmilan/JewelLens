class CategoryBySlugModel {
    CategoryBySlugModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final int? status;
    final String? message;
    final Data? data;

    factory CategoryBySlugModel.fromJson(Map<String, dynamic> json){ 
        return CategoryBySlugModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
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

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
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
