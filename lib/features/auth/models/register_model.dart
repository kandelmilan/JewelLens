class RegisterModel {
    RegisterModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final int? status;
    final String? message;
    final Data? data;

    factory RegisterModel.fromJson(Map<String, dynamic> json){ 
        return RegisterModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.user,
        required this.token,
    });

    final User? user;
    final String? token;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            user: json["user"] == null ? null : User.fromJson(json["user"]),
            token: json["token"],
        );
    }

}

class User {
    User({
        required this.name,
        required this.email,
        required this.password,
        required this.phone,
        required this.address,
        required this.avatar,
        required this.addresses,
        required this.provider,
        required this.role,
        required this.wishlist,
        required this.id,
        required this.shippingProfile,
        required this.cart,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    final String? name;
    final String? email;
    final String? password;
    final String? phone;
    final String? address;
    final String? avatar;
    final List<Address> addresses;
    final String? provider;
    final String? role;
    final List<dynamic> wishlist;
    final String? id;
    final ShippingProfile? shippingProfile;
    final List<dynamic> cart;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
            name: json["name"],
            email: json["email"],
            password: json["password"],
            phone: json["phone"],
            address: json["address"],
            avatar: json["avatar"],
            addresses: json["addresses"] == null ? [] : List<Address>.from(json["addresses"]!.map((x) => Address.fromJson(x))),
            provider: json["provider"],
            role: json["role"],
            wishlist: json["wishlist"] == null ? [] : List<dynamic>.from(json["wishlist"]!.map((x) => x)),
            id: json["_id"],
            shippingProfile: json["shippingProfile"] == null ? null : ShippingProfile.fromJson(json["shippingProfile"]),
            cart: json["cart"] == null ? [] : List<dynamic>.from(json["cart"]!.map((x) => x)),
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            v: json["__v"],
        );
    }

}

class Address {
    Address({
        required this.label,
        required this.address,
        required this.isDefault,
        required this.id,
    });

    final String? label;
    final String? address;
    final bool? isDefault;
    final String? id;

    factory Address.fromJson(Map<String, dynamic> json){ 
        return Address(
            label: json["label"],
            address: json["address"],
            isDefault: json["isDefault"],
            id: json["_id"],
        );
    }

}

class ShippingProfile {
    ShippingProfile({
        required this.province,
        required this.district,
        required this.city,
        required this.wardNo,
        required this.streetAddress,
        required this.houseNo,
        required this.landmark,
    });

    final String? province;
    final String? district;
    final String? city;
    final String? wardNo;
    final String? streetAddress;
    final String? houseNo;
    final String? landmark;

    factory ShippingProfile.fromJson(Map<String, dynamic> json){ 
        return ShippingProfile(
            province: json["province"],
            district: json["district"],
            city: json["city"],
            wardNo: json["wardNo"],
            streetAddress: json["streetAddress"],
            houseNo: json["houseNo"],
            landmark: json["landmark"],
        );
    }

}
