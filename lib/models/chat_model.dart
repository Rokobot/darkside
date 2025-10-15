class ChatModel {
  final int id;
  final dynamic orderId;
  final String chatableType;
  final dynamic chatableId;
  final String description;
  final bool isRead;
  final bool isReadAdmin;
  final String createdAt;
  final String updatedAt;
  final String formattedDate;
  final Chatable chatable;

  ChatModel({
    required this.id,
    required this.orderId,
    required this.chatableType,
    required this.chatableId,
    required this.description,
    required this.isRead,
    required this.isReadAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.formattedDate,
    required this.chatable,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      orderId: json['order_id'],
      chatableType: json['chatable_type'],
      chatableId: json['chatable_id'],
      description: json['description'],
      isRead: json['is_read'] == 1,
      isReadAdmin: json['is_read_admin'] == 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      formattedDate: json['formatted_date'],
      chatable: Chatable.fromJson(json['chatable']),
    );
  }
}

class Chatable {
  final int id;
  final String username;
  final String phone;
  final bool lastSeenActivity;
  final String? imgPath; // Nullable as not all have imgPath

  Chatable({
    required this.id,
    required this.username,
    required this.phone,
    required this.lastSeenActivity,
    this.imgPath,
  });

  factory Chatable.fromJson(Map<String, dynamic> json) {
    return Chatable(
      id: json['id'],
      username: json['username'],
      phone: json['phone'],
      lastSeenActivity: json['last-seen-activity'] ?? false,
      imgPath: json['imgPath'],
    );
  }
}
