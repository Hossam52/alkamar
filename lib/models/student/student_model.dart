import 'package:alqamar/models/attendance/attendance_model.dart';
import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/models/homework/homework_model.dart';
import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/models/payments/payments_model.dart';
import 'package:alqamar/models/student_status_enum.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:flutter/material.dart';

class StudentExamResultRespnonse {
  final bool status;
  final List<StudentModel> students;
  final List<ExamModel> exams;

  StudentExamResultRespnonse(
      {required this.status, required this.students, required this.exams});

  factory StudentExamResultRespnonse.fromJson(Map<String, dynamic> map) {
    return StudentExamResultRespnonse(
      status: map['status'] ?? false,
      students: List<StudentModel>.from(
          map['students']?.map((x) => StudentModel.fromJson(x))),
      exams:
          List<ExamModel>.from(map['exams']?.map((x) => ExamModel.fromJson(x))),
    );
  }

  //For append collective exams
  StudentExamResultRespnonse appendCollectiveExams(Set<int> examIds) {
    final examList =
        exams.where((element) => examIds.contains(element.id)).toList();
    int totalGrade = 0;
    for (var element in examList) {
      totalGrade += element.maxGrade;
    }
    final ExamModel ex = ExamModel(
        id: 0,
        withoutInteract: true,
        stageId: exams[0].stageId,
        title: 'مجمع',
        maxGrade: totalGrade,
        examDate: DateTime.now().toIso8601String());

    exams.add(ex);
    for (int i = 0; i < students.length; i++) {
      double totalGrades = 0;
      for (var exam in examList) {
        totalGrades += students[i].getGradeByExamId(exam.id);
      }
      students[i].appendGradeModel(ex, totalGrades);
    }
    return this;
  }
}

class StudentAttendanceRespnonse {
  final bool status;
  final List<StudentModel> students;
  final List<LectureModel> lectures;

  StudentAttendanceRespnonse(
      {required this.status, required this.students, required this.lectures});

  factory StudentAttendanceRespnonse.fromJson(Map<String, dynamic> map) {
    return StudentAttendanceRespnonse(
      status: map['status'] ?? false,
      students: List<StudentModel>.from(
          map['students']?.map((x) => StudentModel.fromJson(x))),
      lectures: List<LectureModel>.from(
          map['lectures']?.map((x) => LectureModel.fromJson(x))),
    );
  }

  void setAttendance(AttendanceModel attendance) {
    int studentIndex =
        students.indexWhere((element) => element.id == attendance.studentId);
    if (studentIndex == -1) return;
    students[studentIndex].setAttendance(attendance);
  }

  void removeAttendance(int studentId, int lecId) {
    int studentIndex =
        students.indexWhere((element) => element.id == studentId);
    if (studentIndex == -1) return;
    int? lecIndex = students[studentIndex]
        .attendances
        ?.indexWhere((element) => element.lecId == lecId);
    if (lecIndex == -1 || lecIndex == null) return;
    students[studentIndex].attendances?[lecIndex].removeAttend();
  }
}

class StudentHomeworksResponse {
  final bool status;
  final List<StudentModel> students;
  final List<LectureModel> lectures;

  StudentHomeworksResponse(
      {required this.status, required this.students, required this.lectures});

  factory StudentHomeworksResponse.fromJson(Map<String, dynamic> map) {
    return StudentHomeworksResponse(
      status: map['status'] ?? false,
      students: List<StudentModel>.from(
          map['students']?.map((x) => StudentModel.fromJson(x))),
      lectures: List<LectureModel>.from(
          map['lectures']?.map((x) => LectureModel.fromJson(x))),
    );
  }
  void setHomework(HomeworkModel homework) {
    int studentIndex =
        students.indexWhere((element) => element.id == homework.studentId);
    if (studentIndex == -1) return;
    students[studentIndex].setHomework(homework);
  }
}

class StudentPaymentsResponse {
  final bool status;
  final List<StudentModel> students;
  final List<PaymentsModel> payments;

  StudentPaymentsResponse(
      {required this.status, required this.students, required this.payments});

  factory StudentPaymentsResponse.fromJson(Map<String, dynamic> map) {
    return StudentPaymentsResponse(
      status: map['status'] ?? false,
      students: List<StudentModel>.from(
          map['students']?.map((x) => StudentModel.fromJson(x))),
      payments: List<PaymentsModel>.from(
          map['payments']?.map((x) => PaymentsModel.fromJson(x))),
    );
  }
  void setPayment(PaymentsModel payment) {
    int studentIndex =
        students.indexWhere((element) => element.id == payment.student_id);
    if (studentIndex == -1) return;
    students[studentIndex].setPayment(payment);
  }
}

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
  final PaymentsModel? last_payment;
  DateTime createdDate;

  final String qr_code_url;
  final String stage;
  final List<GradeModel>? grades;
  final List<AttendanceModel>? attendances;
  final List<HomeworkModel>? homeworks;
  final List<PaymentsModel>? payments;

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
    required this.last_payment,
    this.grades,
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
      grades: grades,
      attendances: attendances,
      homeworks: homeworks,
      payments: payments,
      last_payment: json['last_payment'] == null
          ? null
          : PaymentsModel.fromJson(json['last_payment']),
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

  String get paymentTitle {
    String? title = last_payment?.title;
    if (title != null) {
      title += ' (${last_payment!.paymentStatus.title})';
    } else {
      return 'لم يسجل';
    }
    return title;
  }
}
