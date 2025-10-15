// models/menu_item_model.dart

class WishlistResponse {
  final int id;
  final int menuId;
  final String menuImage;
  final String title;
  final int price;
  final String showPrice;

  WishlistResponse({
    required this.id,
    required this.menuId,
    required this.menuImage,
    required this.title,
    required this.price,
    required this.showPrice,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      id: json['id'],
      menuId: json['menu_id'],
      menuImage: json['menu_image'],
      title: json['title'],
      price: json['price'],
      showPrice: json['show_price'],
    );
  }
}
