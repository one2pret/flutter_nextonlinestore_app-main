import 'dart:convert';

class AuthResponseModel {
  final String? token;
  final User? user;

  AuthResponseModel({this.token, this.user});

  factory AuthResponseModel.fromMap(Map<String, dynamic> map) {
    return AuthResponseModel(
      token: map['data']?['token'],
      user: map['data']?['user'] != null
          ? User.fromMap(map['data']['user'])
          : null,
    );
  }

  factory AuthResponseModel.fromJson(String source) =>
      AuthResponseModel.fromMap(jsonDecode(source));
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;

  User({this.id, this.name, this.email, this.phone, this.role});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt(),
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
      };

  String toJson() => jsonEncode(toMap());
  factory User.fromJson(String source) => User.fromMap(jsonDecode(source));
}
