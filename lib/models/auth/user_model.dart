// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:alqamar/models/auth/permission_model.dart';
import 'package:alqamar/models/auth/user_role_enum.dart';
import 'package:alqamar/models/permissions/available_permissions_model.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final UserRoleEnum roleEnum;
  AllPermissionsModel? permissions;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.permissions,
    required this.role,
  }) : roleEnum = UserRole.byName(role);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      permissions: map['permissions'] == null
          ? null
          : AllPermissionsModel.fromMap(map['permissions']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email,phone: $phone)';
  }

  List<PermissionModel> get allUserPermissions {
    if (permissions == null) return [];
    return [
      if (permissions?.assistants != null) permissions!.assistants!,
      if (permissions?.attendances != null) permissions!.attendances!,
      if (permissions?.exams != null) permissions!.exams!,
      if (permissions?.grades != null) permissions!.grades!,
      if (permissions?.homeworks != null) permissions!.homeworks!,
      if (permissions?.lectures != null) permissions!.lectures!,
      if (permissions?.students != null) permissions!.students!,
      if (permissions?.student_payments != null) permissions!.student_payments!,
      if (permissions?.payments != null) permissions!.payments!,
    ];
  }
}

class AuthUserModel {
  final User user;
  final String access_token;

  AuthUserModel({required this.user, required this.access_token});

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'access_token': access_token,
    };
  }

  factory AuthUserModel.fromMap(Map<String, dynamic> map) {
    return AuthUserModel(
      user: User.fromMap(map['user']),
      access_token: map['access_token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthUserModel.fromJson(String source) =>
      AuthUserModel.fromMap(json.decode(source));
}

class AllUsersModel {
  final List<User> users;
  final List<PermissionModel> available_permissions;

  AllUsersModel({required this.available_permissions, required this.users});

  factory AllUsersModel.fromMap(Map<String, dynamic> map) {
    return AllUsersModel(
      users: List<User>.from(map['users']?.map((x) => User.fromMap(x))),
      available_permissions: List<PermissionModel>.from(
          map['available_permissions']?.map((x) => PermissionModel.fromMap(x))),
    );
  }
}
