class AddReservationModel {
  final String table;
  final String name;
  final String email;
  final String number;
  final String date;
  final String timeFrom;
  final String timeTo;
  final String person;
  final String? message;

  AddReservationModel({
    required this.table,
    required this.name,
    required this.email,
    required this.number,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    required this.person,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'table': table,
      'name': name,
      'email': email,
      'number': number,
      'date': date,
      'time_form': timeFrom,
      'time_to': timeTo,
      'person': person,
      'message': message,
    };
  }

  factory AddReservationModel.fromJson(Map<String, dynamic> json) {
    return AddReservationModel(
      table: json['table'],
      name: json['name'],
      email: json['email'],
      number: json['number'],
      date: json['date'],
      timeFrom: json['time_form'],
      timeTo: json['time_to'],
      person: json['person'],
      message: json['message'],
    );
  }
}
