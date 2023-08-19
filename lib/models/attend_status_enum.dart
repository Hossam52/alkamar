import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:flutter/material.dart';

enum AttendStatusEnum { attend, late, forgot, cancel, undefined }

extension AttendStatusMethods on AttendStatusEnum {
  static AttendStatusEnum getAttend(int? index) {
    switch (index) {
      case 1:
        return AttendStatusEnum.attend;
      case 2:
        return AttendStatusEnum.late;
      case 3:
        return AttendStatusEnum.forgot;
      default:
        return AttendStatusEnum.undefined;
    }
  }

  String get getAttendanceText {
    switch (this) {
      case AttendStatusEnum.attend:
        return 'حضر';
      case AttendStatusEnum.late:
        return 'متأخر';
      case AttendStatusEnum.forgot:
        return 'نسيان المتابعة';
      case AttendStatusEnum.cancel:
        return 'الغاء الحضور';
      default:
        return '-';
    }
  }

  Color get getAttendanceColor {
    switch (this) {
      case AttendStatusEnum.attend:
        return ColorManager.attendedColor;
      case AttendStatusEnum.late:
        return ColorManager.isLateColor;
      case AttendStatusEnum.forgot:
        return ColorManager.forgotColor;
      case AttendStatusEnum.cancel:
        return ColorManager.cancelColor;

      default:
        return Colors.transparent;
    }
  }

  int? get getAttendStatusIndex {
    switch (this) {
      case AttendStatusEnum.attend:
        return 1;
      case AttendStatusEnum.late:
        return 2;
      case AttendStatusEnum.forgot:
        return 3;
      case AttendStatusEnum.cancel:
        return null;

      default:
        return 0;
    }
  }
}
