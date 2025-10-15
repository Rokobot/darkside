// models/order_model.dart

class OrderResponse {
  final int id;
  final String orderNumber;
  final String foodStatus;
  final String total;
  final String showTotal;
  final String image;
  final String createdAt;
  final String status;
  final int statusLevel;

  OrderResponse({
    required this.id,
    required this.orderNumber,
    required this.foodStatus,
    required this.total,
    required this.showTotal,
    required this.image,
    required this.createdAt,
    required this.status,
    required this.statusLevel,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id'],
      orderNumber: json['order_number'],
      foodStatus: json['food_status'],
      total: json['total'],
      showTotal: json['show_total'],
      image: json['menus'],
      createdAt: json['created_at'],
      status: json['status'],
      statusLevel: json['status_level'],
    );
  }
}

// OrderItem Model
class OrderItem {
  final int id;
  final Menu menu;
  final Map<String, dynamic> variant;
  final dynamic status;
  final String price;
  final String quantity;
  final List<dynamic> addons;

  OrderItem({
    required this.id,
    required this.menu,
    required this.variant,
    required this.status,
    required this.price,
    required this.quantity,
    required this.addons,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      menu: Menu.fromJson(json['menu']),
      variant: json['variant'] ?? {},
      status: json['status'],
      price: json['price'],
      quantity: json['quantity'],
      addons: json['addons'] ?? [],
    );
  }
}

// Menu Model
class Menu {
  final int id;
  final Details details;
  final int price;
  final String showPrice;
  final String thumbnail;
  final List<MenuImage> images;
  final List<dynamic> addons;
  final List<dynamic> rating;
  final List<dynamic> variants;
  final Category category;

  Menu({
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

  factory Menu.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['images'] as List;
    List<MenuImage> imagesList = imagesJson.map((i) => MenuImage.fromJson(i)).toList();

    return Menu(
      id: json['id'],
      details: Details.fromJson(json['details']),
      price: json['price'],
      showPrice: json['show_price'],
      thumbnail: json['thumbnail'],
      images: imagesList,
      addons: json['addons'] ?? [],
      rating: json['rating'] ?? [],
      variants: json['variants'] ?? [],
      category: Category.fromJson(json['category']),
    );
  }
}

// Details Model
class Details {
  final int id;
  final String title;
  final String shortDetails;
  final String details;

  Details({
    required this.id,
    required this.title,
    required this.shortDetails,
    required this.details,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      id: json['id'],
      title: json['title'],
      shortDetails: json['short_details'],
      details: json['details'],
    );
  }
}

// MenuImage Model
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

// Category Model
class Category {
  final int id;
  final String name;
  final String image;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
