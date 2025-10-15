// models/profile_model.dart
class ProfileModel {
  final int id;
  final dynamic firstname;
  final dynamic lastname;
  final dynamic username;
  final dynamic email;
  final dynamic languageId;
  final dynamic address;
  final dynamic phone;
  final dynamic phoneCode;
  final dynamic country;
  final dynamic countryCode;
  final dynamic image;

  ProfileModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.languageId,
    required this.address,
    required this.phone,
    required this.phoneCode,
    required this.country,
    required this.countryCode,
    required this.image,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'language_id': languageId,
      'address': address,
      'phone': phone,
      'phone_code': phoneCode,
      'country': country,
      'country_code': countryCode,
      'image': image,
    };
  }
}

// models/language_model.dart
class LanguageModel {
  final int id;
  final String name;
  final String shortName;
  final String flag;
  final bool rtl;

  LanguageModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.flag,
    required this.rtl,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'],
      name: json['name'],
      shortName: json['short_name'],
      flag: json['flag'],
      rtl: json['rtl'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_name': shortName,
      'flag': flag,
      'rtl': rtl ? 1 : 0,
    };
  }
}
