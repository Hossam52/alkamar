import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:flutter/material.dart';

class GradeModel {
  int id;
  int stageId;
  int? groupId;
  String title;
  int maxGrade;
  DateTime examDate;
  int? gradeId;
  int? studentId;
  num? grade;
  int? examId;

  bool withoutInteract;

  GradeModel({
    required this.id,
    required this.stageId,
    required this.title,
    required this.maxGrade,
    required this.examDate,
    this.groupId,
    this.gradeId,
    this.studentId,
    this.grade,
    this.examId,
    this.withoutInteract = false,
  });
  factory GradeModel.fromExam(ExamModel exam) {
    return GradeModel(
      id: exam.id,
      stageId: exam.stageId,
      title: exam.title,
      maxGrade: exam.maxGrade,
      examDate: exam.date,
      examId: exam.id,
    );
  }
  GradeModel.empty()
      : id = 0,
        title = '',
        maxGrade = 0,
        examDate = DateTime.now(),
        withoutInteract = false,
        stageId = 1;

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'],
      stageId: json['stage_id'] ?? 0,
      groupId: json['group_id'],
      title: json['title'],
      maxGrade: json['max_grade'],
      examDate: DateTime.parse(json['exam_date']),
      gradeId: json['grade_id'],
      studentId: json['student_id'],
      grade: json['grade'],
      examId: json['exam_id'],
    );
  }
  String get gradeFromMaxGrade => '$grade من $maxGrade';
  double get gradePercent => (grade == null) ? 0 : grade! / maxGrade * 100;
  void setGrade(num grade) {
    this.grade = grade;
  }

  dynamic get gradeWithoutRatio {
    if (grade == null) return 0;
    int integerValue = grade!.toInt();
    if (grade! > integerValue) {
      return grade;
    } else {
      return integerValue;
    }
  }

  Color get generateColor {
    if (grade == null) return Colors.transparent;
    if (gradePercent == 100) return ColorManager.percent100Color;
    if (gradePercent >= 85 && gradePercent < 100) {
      return ColorManager.percent85To100Color;
    }
    if (gradePercent >= 70 && gradePercent < 85) {
      return ColorManager.percent70To85Color;
    }
    if (gradePercent >= 50 && gradePercent < 70) {
      return ColorManager.percent50To70Color;
    }

    return ColorManager.percentLessThan50Color;
  }

  String get gradeContentReport {
    String text = '''
\t - $title يوم ${Methods.formatDate(examDate)} حصل علي  $gradeFromMaxGrade''';

    return text;
  }
}
