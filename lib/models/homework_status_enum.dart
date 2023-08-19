import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:flutter/material.dart';

enum HomeworkStatusEnum { done, incomplete, notDone, undefined }

extension HomeworkStatusMethods on HomeworkStatusEnum {
  static HomeworkStatusEnum getHomework(int? index) {
    switch (index) {
      case 1:
        return HomeworkStatusEnum.done;
      case 2:
        return HomeworkStatusEnum.incomplete;
      case 3:
        return HomeworkStatusEnum.notDone;
      default:
        return HomeworkStatusEnum.undefined;
    }
  }

  String get getHomeworkText {
    switch (this) {
      case HomeworkStatusEnum.done:
        return 'معمول';
      case HomeworkStatusEnum.incomplete:
        return 'غير مكتمل';
      case HomeworkStatusEnum.notDone:
        return 'بدون واجب';
      default:
        return '-';
    }
  }

  Color get getHomeworkColor {
    switch (this) {
      case HomeworkStatusEnum.done:
        return ColorManager.attendedColor;
      case HomeworkStatusEnum.incomplete:
        return ColorManager.forgotColor;
      case HomeworkStatusEnum.notDone:
        return ColorManager.isLateColor;

      default:
        return Colors.transparent;
    }
  }

  int get getHomeworkStatusIndex {
    switch (this) {
      case HomeworkStatusEnum.done:
        return 1;
      case HomeworkStatusEnum.incomplete:
        return 2;
      case HomeworkStatusEnum.notDone:
        return 3;

      default:
        return 0;
    }
  }
}
