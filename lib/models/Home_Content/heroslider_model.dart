class HeroSliderModel {
    HeroSliderModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final int? status;
    final String? message;
    final List<Datum> data;

    factory HeroSliderModel.fromJson(Map<String, dynamic> json){ 
        return HeroSliderModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

}

class Datum {
    Datum({
        required this.id,
        required this.title,
        required this.subtitle,
        required this.image,
        required this.link,
        required this.status,
        required this.order,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    final String? id;
    final String? title;
    final String? subtitle;
    final String? image;
    final String? link;
    final String? status;
    final int? order;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            id: json["_id"],
            title: json["title"],
            subtitle: json["subtitle"],
            image: json["image"],
            link: json["link"],
            status: json["status"],
            order: json["order"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            v: json["__v"],
        );
    }

}
