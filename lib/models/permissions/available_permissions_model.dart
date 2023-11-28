// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:alqamar/models/auth/permission_model.dart';

class PermissionModel {
  int id;
  String module;
  String title;
  bool view;
  bool create;
  bool update;
  bool delete;

  PermissionModel(
      {this.id = 0,
      this.view = false,
      this.module = '',
      this.title = '',
      this.create = false,
      this.update = false,
      this.delete = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'module': module,
      'view': view,
      'create': create,
      'update': update,
      'delete': delete,
    };
  }

  factory PermissionModel.fromMap(Map<String, dynamic> map) {
    return PermissionModel(
      id: map['id']?.toInt() ?? 0,
      module: map['module'] ?? '',
      title: map['title'] ?? '',
      view: map['view'] ?? false,
      create: map['create'] ?? false,
      update: map['update'] ?? false,
      delete: map['delete'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PermissionModel.fromJson(String source) =>
      PermissionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return '(id: $id, module: $module, view: $view, create: $create, update: $update, delete: $delete)';
  }
}
