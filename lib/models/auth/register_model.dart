import 'dart:convert';

import 'user_model.dart';

class RegisterModel {
  final bool status;
  final String message;
  final AuthUserModel user;
  RegisterModel({
    required this.status,
    required this.message,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'user': user.toMap(),
    };
  }

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      status: map['status'] ?? false,
      message: map['message'] ?? '',
      user: AuthUserModel.fromMap(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterModel.fromJson(String source) =>
      RegisterModel.fromMap(json.decode(source));
}
