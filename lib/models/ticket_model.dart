class UserModel {
  final int id;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final dynamic languageId;
  final String? address;
  final String phone;
  final dynamic phoneCode;
  final dynamic country;
  final dynamic countryCode;
  final String image;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    this.languageId,
    this.address,
    required this.phone,
    required this.phoneCode,
    required this.country,
    required this.countryCode,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      email: json['email'],
      languageId: json['language_id'],
      address: json['address'],
      phone: json['phone'],
      phoneCode: json['phone_code'],
      country: json['country'],
      countryCode: json['country_code'],
      image: json['image'],
    );
  }
}

class MessageModel {
  final int id;
  final dynamic supportTicketId;
  final dynamic adminId;
  final String message;
  final String createdAt;
  final List<String> attachments;

  MessageModel({
    required this.id,
    required this.supportTicketId,
    this.adminId,
    required this.message,
    required this.createdAt,
    required this.attachments,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      supportTicketId: json['support_ticket_id'],
      adminId: json['admin_id'],
      message: json['message'],
      createdAt: json['created_at'],
      attachments: List<String>.from(json['attachment'].map((x) => x['file'])),
    );
  }
}

class TicketModel {
  final int id;
  final String ticket;
  final String subject;
  final String lastReply;
  final dynamic status;
  final List<MessageModel> messages;
  final UserModel user;

  TicketModel({
    required this.id,
    required this.ticket,
    required this.subject,
    required this.lastReply,
    required this.status,
    required this.messages,
    required this.user,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      ticket: json['ticket'],
      subject: json['subject'],
      lastReply: json['last_reply'],
      status: json['status'],
      messages: List<MessageModel>.from(json['messages'].map((x) => MessageModel.fromJson(x))),
      user: UserModel.fromJson(json['user']),
    );
  }
}
