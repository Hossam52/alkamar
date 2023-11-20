import 'dart:developer';

import 'package:alqamar/models/attend_status_enum.dart';
import 'package:alqamar/models/attendance/attendance_model.dart';
import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/models/homework/homework_model.dart';
import 'package:alqamar/models/payments/payments_model.dart';
import 'package:alqamar/models/student_status_enum.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:flutter/material.dart';

class StudentListResponseModel {
  final bool status;
  final String message;
  final List<StudentModel> students;
  StudentListResponseModel({
    required this.status,
    required this.message,
    required this.students,
  });

  factory StudentListResponseModel.fromMap(Map<String, dynamic> map) {
    return StudentListResponseModel(
      status: map['status'] ?? false,
      message: map['message'] ?? '',
      students: List<StudentModel>.from(
          map['students']?.map((x) => StudentModel.fromJson(x))),
    );
  }
}

class StudentModel {
  final int id;
  final int stageId;
  final String code;
  final String name;
  final String school;
  final String fatherPhone;
  final String motherPhone;
  final String studentPhone;
  final String whatsapp;
  final String address;
  final String gender;
  final String problems;
  final bool student_status; //false for monqate3
  final StudentStatus studentStatusEnum;
  final String qrCodePath;
  final String created_at;
  final PaymentsModel? last_month_payment;
  final PaymentsModel? current_month_payment;
  // final List<PaymentsModel>? last_paymets;
  final int? group_id;
  final String? group_title;
  DateTime createdDate;

  final String qr_code_url;
  final String stage;
  AttendanceModel? last_attendance;
  List<GradeModel>? grades;
  List<AttendanceModel>? attendances;
  List<HomeworkModel>? homeworks;
  List<PaymentsModel>? payments;

  StudentModel({
    required this.id,
    required this.stageId,
    required this.code,
    required this.name,
    required this.school,
    required this.fatherPhone,
    required this.motherPhone,
    required this.studentPhone,
    required this.whatsapp,
    required this.address,
    required this.gender,
    required this.problems,
    required this.student_status,
    required this.qrCodePath,
    required this.qr_code_url,
    required this.created_at,
    required this.stage,
    required this.last_month_payment,
    required this.current_month_payment,
    // required this.last_paymets,
    this.group_id,
    this.group_title,
    this.grades,
    this.last_attendance,
    this.attendances,
    this.homeworks,
    this.payments,
  })  : createdDate = DateTime.parse(created_at),
        studentStatusEnum =
            StudentStatusMethods.getStudentStatusEnum(student_status ? 1 : 0);

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    var gradeList = json['grades'] as List<dynamic>?;
    List<GradeModel>? grades;
    if (gradeList != null) {
      grades =
          gradeList.map((gradeJson) => GradeModel.fromJson(gradeJson)).toList();
    }

    var attendanceList = json['attendances'] as List<dynamic>?;
    List<AttendanceModel>? attendances;
    if (attendanceList != null) {
      attendances = attendanceList
          .map((attendanceJson) => AttendanceModel.fromJson(attendanceJson))
          .toList();
    }
    List<HomeworkModel>? homeworks;
    var homeworksList = json['homeworks'] as List<dynamic>?;
    if (homeworksList != null) {
      homeworks = homeworksList
          .map((attendanceJson) => HomeworkModel.fromJson(attendanceJson))
          .toList();
    }
    List<PaymentsModel>? payments;
    var paymentsList = json['payments'] as List<dynamic>?;
    if (paymentsList != null) {
      payments = paymentsList
          .map((payment) => PaymentsModel.fromJson(payment))
          .toList();
    }
    // List<PaymentsModel>? lastPayments;
    // var lastPaymentsList = json['last_payments'] as List<dynamic>?;
    // if (lastPaymentsList != null) {
    //   lastPayments = lastPaymentsList
    //       .map((payment) => PaymentsModel.fromJson(payment))
    //       .toList();
    // }

    return StudentModel(
      id: json['id'],
      stageId: json['stage_id'],
      code: json['code'],
      name: json['name'],
      school: json['school'] ?? '',
      fatherPhone: json['father_phone'] ?? '',
      motherPhone: json['mother_phone'] ?? '',
      studentPhone: json['student_phone'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'],
      problems: json['problems'] ?? '',
      student_status: json['student_status'] ?? true,
      qrCodePath: json['qr_code_path'],
      created_at: json['created_at'],
      qr_code_url: json['qr_code_url'],
      stage: json['stage'] ?? '',
      last_month_payment: json['last_month_payment'] == null
          ? null
          : PaymentsModel.fromJson(json['last_month_payment']),
      current_month_payment: json['current_month_payment'] == null
          ? null
          : PaymentsModel.fromJson(json['current_month_payment']),
      last_attendance: json['last_attendance'] == null
          ? null
          : AttendanceModel.fromJson(json['last_attendance']),
      grades: grades,
      attendances: attendances,
      homeworks: homeworks,
      payments: payments,
      // last_paymets: lastPayments,
      group_id: json['group_id'],
      group_title: json['group_title'],
    );
  }
  String get generateCodeWithName => '$code - $name';
  String get studentStatusText => !student_status ? 'متوقف' : 'منتظم';
  void setHomework(HomeworkModel homework) {
    final homeworkIndex =
        homeworks?.indexWhere((element) => element.id == homework.lecId) ?? -1;
    if (homeworkIndex == -1) return;
    homeworks![homeworkIndex].homeworkStatusEnum = homework.homeworkStatusEnum;
    homeworks![homeworkIndex].homework_status = homework.homework_status;
    homeworks![homeworkIndex].studentId = id;
    homeworks![homeworkIndex].lecId = homework.lecId;
  }

  void setGrade(GradeModel grade) {
    final gradeIndex =
        grades?.indexWhere((element) => element.examId == grade.examId) ?? -1;
    if (gradeIndex == -1) return;
    grades?[gradeIndex] = grade;
  }

  void setPayment(PaymentsModel payment) {
    final paymentIndex =
        payments?.indexWhere((element) => element.id == payment.payment_id) ??
            -1;
    if (paymentIndex == -1) return;
    payments![paymentIndex].paymentStatus = payment.paymentStatus;
    payments![paymentIndex].payment_status = payment.payment_status;
    payments![paymentIndex].student_id = id;
    payments![paymentIndex].payment_id = payment.payment_id;
  }

  void setAttendance(AttendanceModel attendance) {
    final attendanceIndex =
        attendances?.indexWhere((element) => element.id == attendance.lecId) ??
            -1;
    if (attendanceIndex == -1) return;
    attendances![attendanceIndex].attendStatusEnum =
        attendance.attendStatusEnum;
    attendances![attendanceIndex].attend_status = attendance.attend_status;
    attendances![attendanceIndex].studentId = id;
    attendances![attendanceIndex].lecId = attendance.lecId;
    attendances![attendanceIndex].group = attendance.group;
  }

  num getGradeByExamId(int examId) {
    final list =
        grades?.where((element) => element.examId == examId).toList() ?? [];
    if (list.isEmpty) return 0;
    return list[0].grade ?? 0;
  }

  Color get getStudentStatusColor {
    if (student_status) {
      return Colors.transparent;
    } else {
      return ColorManager.studentStatusColor;
    }
  }

  void appendGradeModel(ExamModel exam, double grade) {
    grades?.add(GradeModel(
        id: 0,
        stageId: exam.stageId,
        title: exam.title,
        maxGrade: exam.maxGrade,
        examDate: exam.date,
        examId: exam.id,
        grade: grade,
        gradeId: 0,
        withoutInteract: true,
        studentId: id));
  }

  String get currentPaymentTitle {
    String? title = current_month_payment?.title;
    if (title != null) {
      title += ' (${current_month_payment!.paymentStatus.title})';
    } else {
      return 'لم يسجل';
    }
    return title;
  }

  String get lastPaymentTitle {
    if (last_month_payment == null) return 'لم يدفع';
    return last_month_payment!.paymentStatus.title;
  }
  // String get paymentTitle {
  //   log(last_paymets.toString());
  //   String? title = last_paymets?.map((e) => '( ${e.title} )').join(' - ');
  //   if (title == null || (last_paymets != null && last_paymets!.isEmpty)) {
  //     return 'لم يسجل ';
  //   }

  //   return title;
  // }

  String get lastAttendanceTitle {
    if (last_attendance == null) return 'غائب';
    return last_attendance!.attendStatusEnum.getAttendanceText;
  }
}
