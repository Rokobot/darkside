class MenuCategoryResponse {
  int id;
  String name;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  MenuCategoryResponse({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuCategoryResponse.fromJson(Map<String, dynamic> json) {
    return MenuCategoryResponse(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
