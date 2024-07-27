import 'dart:math';

import 'package:alqamar/shared/network/endpoints.dart';

import '../../../constants/constants.dart';
import '../remote/app_dio_helper.dart';

class AppServices {
  AppServices._();

  // Stages endpoints
  static Future<Map<String, dynamic>> getStages() async {
    try {
      final response = await AppDioHelper.getData(
        url: EndPoints.stages,
        token: Constants.token,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Students endpoints
  static Future<Map<String, dynamic>> createStudent({
    required int stageId,
    required String code,
    required String name,
    required String school,
    required String fatherPhone,
    required String motherPhone,
    required String studentPhone,
    required String whatsapp,
    required String address,
    required String gender,
    required String problems,
    int? studentStatus,
    int? groupId,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.createStudent,
        token: Constants.token,
        data: {
          'stage_id': stageId,
          'code': code,
          'name': name,
          'school': school,
          'father_phone': fatherPhone,
          'mother_phone': motherPhone,
          'student_phone': studentPhone,
          'whatsapp': whatsapp,
          'address': address,
          'gender': gender,
          'problems': problems,
          if (studentStatus != null) 'student_status': studentStatus,
          if (groupId != null) 'group_id': groupId,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateStudent({
    required int studentId,
    required String? code,
    required String? name,
    required String? school,
    required String? fatherPhone,
    required String? motherPhone,
    required String? studentPhone,
    required String? whatsapp,
    required String? address,
    required String? problems,
    required int? studentStatus,
    required int? groupId,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.updateStudent,
        token: Constants.token,
        data: {
          'student_id': studentId,
          'code': code,
          'name': name,
          'school': school,
          'father_phone': fatherPhone,
          'mother_phone': motherPhone,
          'student_phone': studentPhone,
          'whatsapp': whatsapp,
          'address': address,
          'problems': problems,
          if (studentStatus != null) 'student_status': studentStatus,
          if (groupId != null) 'group_id': groupId,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> listStudents(
      int stageId, int page) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.listStudents,
        token: Constants.token,
        data: {
          'stage_id': stageId,
          'page': page,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> studentAttendances(
      int stageId, int page) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.studentAttendances,
        token: Constants.token,
        data: {
          'stage_id': stageId,
          'page': max(page, 1),
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> studentHomeworks(
      int stageId, int page) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.studenthomeworks,
        token: Constants.token,
        data: {'stage_id': stageId, 'page': max(page, 1)},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> studentPayments(
      int stageId, int page) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.studentpayments,
        token: Constants.token,
        data: {
          'stage_id': stageId,
          'page': max(page, 1),
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> storeStudentPayment({
    required String student_id,
    required String payment_id,
    required int payment_status,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.storeStudentPayment,
        token: Constants.token,
        data: {
          'student_id': student_id,
          'payment_id': payment_id,
          'payment_status': payment_status,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> storePayment({
    required String title,
    required int stage_id,
    required DateTime paymentDate,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.createPayment,
        token: Constants.token,
        data: {
          'stage_id': stage_id,
          'title': title,
          'month': paymentDate.month,
          'year': paymentDate.year,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getPaymentStats(
    int paymentId,
  ) async {
    try {
      final response = await AppDioHelper.getData(
          url: EndPoints.paymentStats,
          token: Constants.token,
          query: {
            'payment_id': paymentId,
          });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getStudentData(String studentId) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.studentData,
        token: Constants.token,
        data: {
          'student_id': studentId,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getStudentProfile(
      String? studentId, String? studentCode) async {
    try {
      final response = await AppDioHelper.getData(
        url: EndPoints.studentProfile,
        token: Constants.token,
        query: {
          if (studentId != null) 'student_id': studentId,
          if (studentCode != null) 'student_code': studentCode,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> generateQrPdf(
      List<int> studentIds) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.generatePdf,
        token: Constants.token,
        data: {
          'student_ids': studentIds,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Exams endpoints
  static Future<Map<String, dynamic>> getAllExams() async {
    try {
      final response = await AppDioHelper.getData(
        url: EndPoints.allExams,
        token: Constants.token,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getExamStats(int examId,
      {String? division, int? groupId}) async {
    try {
      final response = await AppDioHelper.getData(
          url: EndPoints.examStats,
          token: Constants.token,
          query: {
            'exam_id': examId,
            'division': division,
            'group_id': groupId,
          });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createExam({
    required String examName,
    required String maxGrade,
    required int stageId,
    required DateTime examDate,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.createExam,
        token: Constants.token,
        data: {
          'stage_id': stageId,
          'title': examName,
          'max_grade': maxGrade,
          'exam_date': examDate.toIso8601String(),
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> collectiveExams({
    required Set<int> examIds,
    required String examName,
    required int stageId,
    required DateTime examDate,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.collectiveExams,
        token: Constants.token,
        data: {
          'exam_ids': examIds.toList(),
          'stage_id': stageId,
          'title': examName,
          'exam_date': examDate.toIso8601String(),
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateExam({
    required int examId,
    String? examName,
    num? maxGrade,
    DateTime? examDate,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.updateExam,
        token: Constants.token,
        data: {
          'exam_id': examId,
          if (examName != null) 'title': examName,
          if (maxGrade != null) 'max_grade': maxGrade,
          if (examDate != null) 'exam_date': examDate.toIso8601String(),
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> deleteExam({
    required int examId,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.deleteExam,
        token: Constants.token,
        data: {
          'exam_id': examId,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Grades endpoints
  static Future<Map<String, dynamic>> storeGrade({
    required int studentId,
    required int? groupId,
    required int examId,
    required num grade,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.storeGrade,
        token: Constants.token,
        data: {
          'student_id': studentId,
          'group_id': groupId,
          'exam_id': examId,
          'grade': grade,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Lectures endpoints
  static Future<Map<String, dynamic>> storeLecture({
    required String lectureName,
    required int stage_id,
    required DateTime lectureDate,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.storeLecture,
        token: Constants.token,
        data: {
          'stage_id': stage_id,
          'title': lectureName,
          'lecture_date': lectureDate.toIso8601String(),
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateLecture({
    required int lectureId,
    String? lectureName,
    DateTime? lectureDate,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.updateLecture,
        token: Constants.token,
        data: {
          'lecture_id': lectureId,
          'title': lectureName,
          'lecture_date': lectureDate?.toIso8601String(),
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> deleteLecture({
    required int lectureId,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.deleteLecture,
        token: Constants.token,
        data: {
          'lecture_id': lectureId,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> lectureStats(
      {required int lecture_id, List<int>? groupIds}) async {
    try {
      final response = await AppDioHelper.getData(
        url: EndPoints.lectureStats,
        token: Constants.token,
        query: {
          'lecture_id': lecture_id,
          if (groupIds != null) 'group_id[]': groupIds
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Attendances endpoints
  static Future<Map<String, dynamic>> storeAttendance({
    required String studentId,
    required String lectureId,
    required int? attend_status,
    required int? groupId,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.storeAttendance,
        token: Constants.token,
        data: {
          'student_id': studentId,
          'lec_id': lectureId,
          if (attend_status != null) 'attend_status': attend_status,
          'attend_group_id': groupId,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Homework endpoints
  static Future<Map<String, dynamic>> storeHomework({
    required String studentId,
    required String lectureId,
    required int homework_status,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.storeHomework,
        token: Constants.token,
        data: {
          'student_id': studentId,
          'lec_id': lectureId,
          'homework_status': homework_status,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Search endpoints
  static Future<Map<String, dynamic>> searchStudent({
    int? stage_id,
    String? code,
    String? name,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.searchStudent,
        token: Constants.token,
        data: {
          if (stage_id != null) 'stage_id': stage_id,
          if (code != null) 'code': code,
          if (name != null) 'name': name,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Groups endpoints
  static Future<Map<String, dynamic>> allGroups({
    int? stageId,
  }) async {
    try {
      final response = await AppDioHelper.getData(
        url: EndPoints.allGroups,
        token: Constants.token,
        query: {
          'stage_id': stageId,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> addGroup({
    required int stageId,
    required String title,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.storeGroups,
        token: Constants.token,
        data: {
          'stage_id': stageId,
          'title': title,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createEmptyStudents({
    required int stageId,
    required int count,
  }) async {
    try {
      final response = await AppDioHelper.postData(
        url: EndPoints.createEmptyStudents,
        token: Constants.token,
        data: {
          'stage_id': stageId,
          'count': count,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
