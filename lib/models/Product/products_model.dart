class ProductsModel {
  ProductsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int? status;
  final String? message;
  final List<Datum> data;

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.stockCount,
    required this.inStock,
    required this.material,
    required this.weight,
    required this.images,
    required this.rating,
    required this.reviews,
    required this.variants,
    required this.specifications,
    required this.careInstructions,
    required this.certifications,
    required this.faqs,
    required this.craftsmanshipStory,
    required this.warranty,
    required this.returnPolicy,
    required this.estimatedDeliveryDays,
    required this.freeShipping,
    required this.codAvailable,
    required this.emiAvailable,
    required this.offerBadge,
    required this.offerEndsAt,
    required this.featured,
    required this.frequentlyBoughtTogether,
    required this.completeLook,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? name;
  final String? slug;
  final String? description;
  final Category? category;
  final int? price;
  final int? originalPrice;
  final int? stockCount;
  final bool? inStock;
  final String? material;
  final String? weight;
  final List<String> images;
  final int? rating;
  final int? reviews;
  final List<Variant> variants;
  final Specifications? specifications;
  final List<String> careInstructions;
  final List<String> certifications;
  final List<Faq> faqs;
  final String? craftsmanshipStory;
  final String? warranty;
  final String? returnPolicy;
  final int? estimatedDeliveryDays;
  final bool? freeShipping;
  final bool? codAvailable;
  final bool? emiAvailable;
  final String? offerBadge;
  final DateTime? offerEndsAt;
  final bool? featured;
  final List<dynamic> frequentlyBoughtTogether;
  final List<dynamic> completeLook;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["_id"],
      name: json["name"],
      slug: json["slug"],
      description: json["description"],
      category: json["category"] == null
          ? null
          : Category.fromJson(json["category"]),
      price: json["price"],
      originalPrice: json["originalPrice"],
      stockCount: json["stockCount"],
      inStock: json["inStock"],
      material: json["material"],
      weight: json["weight"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      rating: json["rating"],
      reviews: json["reviews"],
      variants: json["variants"] == null
          ? []
          : List<Variant>.from(
              json["variants"]!.map((x) => Variant.fromJson(x)),
            ),
      specifications: json["specifications"] == null
          ? null
          : Specifications.fromJson(json["specifications"]),
      careInstructions: json["careInstructions"] == null
          ? []
          : List<String>.from(json["careInstructions"]!.map((x) => x)),
      certifications: json["certifications"] == null
          ? []
          : List<String>.from(json["certifications"]!.map((x) => x)),
      faqs: json["faqs"] == null
          ? []
          : List<Faq>.from(json["faqs"]!.map((x) => Faq.fromJson(x))),
      craftsmanshipStory: json["craftsmanshipStory"],
      warranty: json["warranty"],
      returnPolicy: json["returnPolicy"],
      estimatedDeliveryDays: json["estimatedDeliveryDays"],
      freeShipping: json["freeShipping"],
      codAvailable: json["codAvailable"],
      emiAvailable: json["emiAvailable"],
      offerBadge: json["offerBadge"],
      offerEndsAt: DateTime.tryParse(json["offerEndsAt"] ?? ""),
      featured: json["featured"],
      frequentlyBoughtTogether: json["frequentlyBoughtTogether"] == null
          ? []
          : List<dynamic>.from(json["frequentlyBoughtTogether"]!.map((x) => x)),
      completeLook: json["completeLook"] == null
          ? []
          : List<dynamic>.from(json["completeLook"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}

class Category {
  Category({
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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
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

class Faq {
  Faq({required this.question, required this.answer, required this.id});

  final String? question;
  final String? answer;
  final String? id;

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json["question"],
      answer: json["answer"],
      id: json["_id"],
    );
  }
}

class Specifications {
  Specifications({
    required this.purity,
    required this.specificationsStyle,
    required this.occassion,
    required this.finish,
    required this.design,
    required this.comfort,
    required this.occasion,
    required this.goldPurity,
    required this.type,
    required this.hallmark,
    required this.material,
    required this.closureType,
    required this.style,
    required this.specificationsOccasion,
  });

  final String? purity;
  final String? specificationsStyle;
  final String? occassion;
  final String? finish;
  final String? design;
  final String? comfort;
  final String? occasion;
  final String? goldPurity;
  final String? type;
  final String? hallmark;
  final String? material;
  final String? closureType;
  final String? style;
  final String? specificationsOccasion;

  factory Specifications.fromJson(Map<String, dynamic> json) {
    return Specifications(
      purity: json["Purity"],
      specificationsStyle: json["style"],
      occassion: json["Occassion"],
      finish: json["Finish"],
      design: json["Design"],
      comfort: json["Comfort"],
      occasion: json["Occasion"],
      goldPurity: json["Gold Purity"],
      type: json["Type"],
      hallmark: json["Hallmark"],
      material: json["Material"],
      closureType: json["Closure Type"],
      style: json["Style "],
      specificationsOccasion: json["Occasion "],
    );
  }
}

class Variant {
  Variant({
    required this.type,
    required this.label,
    required this.options,
    required this.id,
  });

  final String? type;
  final String? label;
  final List<Option> options;
  final String? id;

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      type: json["type"],
      label: json["label"],
      options: json["options"] == null
          ? []
          : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
      id: json["_id"],
    );
  }
}

class Option {
  Option({
    required this.value,
    required this.priceAdjustment,
    required this.id,
  });

  final String? value;
  final int? priceAdjustment;
  final String? id;

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      value: json["value"],
      priceAdjustment: json["priceAdjustment"],
      id: json["_id"],
    );
  }
}
