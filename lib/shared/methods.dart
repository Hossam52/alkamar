import 'package:alqamar/models/permissions/available_permissions_model.dart';
import 'package:intl/intl.dart';

import '../widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class Methods {
  Methods._();
  static Future<dynamic> navigateTo(BuildContext context, Widget widget) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
  }

  static void showSnackBar(BuildContext context, String text,
      [int seconds = 2]) {
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: Colors.red,
    );
  }

  static void showSuccessSnackBar(BuildContext context, String text,
      [int seconds = 2]) async {
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: Colors.green,
    );
  }

  static void canEditPermission(PermissionModel? permission) {
    if (permission == null || !permission.update) {
      throw 'ليس لديك صلاحية للقيام بهذا';
    }
  }

  static void canCreatePermission(PermissionModel? permission) {
    if (permission == null || !permission.create) {
      throw 'ليس لديك صلاحية للقيام بهذا';
    }
  }

  static void canViewPermission(PermissionModel? permission) {
    if (permission == null || !permission.view) {
      throw 'ليس لديك صلاحية للقيام بهذا';
    }
  }

  static void canDeletePermission(PermissionModel? permission) {
    if (permission == null || !permission.delete) {
      throw 'ليس لديك صلاحية للقيام بهذا';
    }
  }

  static String formatDate(DateTime date,
      {String format = 'MM/dd', bool appendYear = false}) {
    if (appendYear) format = 'yyyy/MM/dd';
    return DateFormat(format).format(date);
  }
}

extension SizeExtensions on BuildContext {
  double get getWidth => size!.width;
  double get getHeight => size!.height;
  double getFactorWidth(double factor) => getWidth * factor;
  double getFactorHeight(double factor) => getHeight * factor;
}
