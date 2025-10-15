class ReservationHistoryModel {
  final String status;
  final List<ReservationHistoryItem> data;
  final String? message;

  ReservationHistoryModel({
    required this.status,
    required this.data,
    this.message,
  });

  factory ReservationHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReservationHistoryModel(
      status: json['status'],
      data: (json['data'] as List)
          .map((item) => ReservationHistoryItem.fromJson(item))
          .toList(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
      'message': message,
    };
  }
}

class ReservationHistoryItem {
  final int id;
  final String name;
  final String email;
  final String number;
  final int person;
  final String timeFrom;
  final String timeTo;
  final String date;
  final int tableId;
  final String? message;

  ReservationHistoryItem({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
    required this.person,
    required this.timeFrom,
    required this.timeTo,
    required this.date,
    required this.tableId,
    this.message,
  });

  factory ReservationHistoryItem.fromJson(Map<String, dynamic> json) {
    return ReservationHistoryItem(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      number: json['number'],
      person: json['person'],
      timeFrom: json['time_from'],
      timeTo: json['time_to'],
      date: json['date'],
      tableId: json['table_id'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'number': number,
      'person': person,
      'time_from': timeFrom,
      'time_to': timeTo,
      'date': date,
      'table_id': tableId,
      'message': message,
    };
  }
}
