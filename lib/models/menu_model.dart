double _parsePrice(String priceString) {
  return double.parse(priceString.replaceAll('\$', '').trim());
}

// models/menu_category_model.dart
class MenuResponse {
  final int id;
  final MenuDetails details;
  final int price;
  final String showPrice;
  final String thumbnail;
  final List<MenuImage> images;
  final List<MenuAddon> addons;
  final List<MenuRating> rating;
  final List<MenuVariant> variants;
  final MenuCategory category;

  MenuResponse({
    required this.id,
    required this.details,
    required this.price,
    required this.showPrice,
    required this.thumbnail,
    required this.images,
    required this.addons,
    required this.rating,
    required this.variants,
    required this.category,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    return MenuResponse(
      id: json['id'],
      details: MenuDetails.fromJson(json['details']),
      // price: _parsePrice(json['price']),
      price: json['price'],
      showPrice: json['show_price'],
      thumbnail: json['thumbnail'],
      images: List<MenuImage>.from(json['images'].map((x) => MenuImage.fromJson(x))),
      addons: List<MenuAddon>.from(json['addons'].map((x) => MenuAddon.fromJson(x))),
      rating: List<MenuRating>.from(json['rating'].map((x) => MenuRating.fromJson(x))),
      variants: List<MenuVariant>.from(json['variants'].map((x) => MenuVariant.fromJson(x))),
      category: MenuCategory.fromJson(json['category']),
    );
  }
}

class MenuDetails {
  final int id;
  final String title;
  final String shortDetails;
  final String details;

  MenuDetails({
    required this.id,
    required this.title,
    required this.shortDetails,
    required this.details,
  });

  factory MenuDetails.fromJson(Map<String, dynamic> json) {
    return MenuDetails(
      id: json['id'],
      title: json['title'],
      shortDetails: json['short_details'],
      details: json['details'],
    );
  }
}

class MenuImage {
  final int id;
  final String image;

  MenuImage({
    required this.id,
    required this.image,
  });

  factory MenuImage.fromJson(Map<String, dynamic> json) {
    return MenuImage(
      id: json['id'],
      image: json['image'],
    );
  }
}

class MenuAddon {
  final int id;
  final String name;
  final double price;
  final String showPrice;
  final String image;
  bool isSelected;

  MenuAddon({
    required this.id,
    required this.name,
    required this.price,
    required this.showPrice,
    required this.image,
    this.isSelected = false,
  });

  factory MenuAddon.fromJson(Map<String, dynamic> json) {
    return MenuAddon(
      id: json['id'],
      name: json['name'],
      price: _parsePrice(json['price']),
      showPrice: json['show_price'],
      image: json['image'],
      isSelected: false,
    );
  }
}

class MenuRating {
  final int id;
  final String rating;
  final String comment;

  MenuRating({
    required this.id,
    required this.rating,
    required this.comment,
  });

  factory MenuRating.fromJson(Map<String, dynamic> json) {
    return MenuRating(
      id: json['id'],
      rating: json['ratting'], // Note the key in JSON is "ratting"
      comment: json['comment'],
    );
  }
}

class MenuVariant {
  final int id;
  final String variantName;
  final double price;
  final String showPrice;

  MenuVariant({
    required this.id,
    required this.variantName,
    required this.price,
    required this.showPrice,
  });

  factory MenuVariant.fromJson(Map<String, dynamic> json) {
    return MenuVariant(
      id: json['id'],
      variantName: json['variant_name'],
      price: _parsePrice(json['price']),
      showPrice: json['show_price'],
    );
  }
}

class MenuCategory {
  final int id;
  final String name;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
