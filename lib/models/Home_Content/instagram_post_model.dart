class InstagramPostModel {
    InstagramPostModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final int? status;
    final String? message;
    final List<Datum> data;

    factory InstagramPostModel.fromJson(Map<String, dynamic> json){ 
        return InstagramPostModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

}

class Datum {
    Datum({
        required this.id,
        required this.image,
        required this.caption,
        required this.likes,
        required this.link,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    final String? id;
    final String? image;
    final String? caption;
    final int? likes;
    final String? link;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            id: json["_id"],
            image: json["image"],
            caption: json["caption"],
            likes: json["likes"],
            link: json["link"],
            status: json["status"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            v: json["__v"],
        );
    }

}
