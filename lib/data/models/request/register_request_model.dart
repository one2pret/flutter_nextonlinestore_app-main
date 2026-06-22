import 'dart:convert';

class RegisterRequestModel {
  final String name;
  final String email;
  final String phone;
  final String password;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      };

  String toJson() => jsonEncode(toMap());
}
