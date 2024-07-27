import 'dart:developer';

import 'package:alqamar/cubits/app_cubit/app_cubit.dart';
import 'package:alqamar/models/attend_status_enum.dart';
import 'package:alqamar/models/attendance/attendance_model.dart';
import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/models/homework/homework_model.dart';
import 'package:alqamar/models/homework_status_enum.dart';
import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/models/payments/payment_status_enum.dart';
import 'package:alqamar/models/payments/payments_model.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/models/student/student_qrs_response.dart';
import 'package:alqamar/models/student/students_paginate_model.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/network/services/app_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/student/student_list_models/student_attendance_respnonse.dart';
import '../../models/student/student_list_models/student_exam_result_respnonse.dart';
import '../../models/student/student_list_models/student_homeworks_response.dart';
import '../../models/student/student_payments_response.dart';
import 'student_states.dart';

//Bloc builder and bloc consumer methods
typedef StudentBlocBuilder = BlocBuilder<StudentCubit, StudentStates>;
typedef StudentBlocConsumer = BlocConsumer<StudentCubit, StudentStates>;

//
class StudentCubit extends Cubit<StudentStates> {
  StudentCubit(this._stage) : super(IntitalStudentState());
  static StudentCubit instance(BuildContext context) =>
      BlocProvider.of<StudentCubit>(context);
  final StageModel? _stage;
  StageModel? get getStage => _stage;
  bool get isLoadingMoreStudents => state is GetMoreStudentLoadingState;
  int paginatedPage(StudentsPaginateModel? paginatedModel) {
    if (paginatedModel == null) {
      return 1;
    } else {
      return paginatedModel.page;
    }
  }

  //Exam results
  StudentExamResultRespnonse? _studentExamResultRespnonse;
  bool get hasLoadedExamRes => _studentExamResultRespnonse != null;
  int? get totalGradesStudents =>
      _studentExamResultRespnonse?.studentsPaginateModel.total_students;
  List<ExamModel> get allExams => _studentExamResultRespnonse?.exams ?? [];
  List<StudentModel> get allStudentGrades =>
      _studentExamResultRespnonse?.students ?? [];
  Future<void> getStudentGrades() async {
    try {
      if (_stage == null) throw 'يجب اختيار المرحلة';

      emit(_studentExamResultRespnonse != null
          ? GetMoreStudentLoadingState()
          : GetStudentGradesLoadingState());
      final res = await AppServices.listStudents(_stage!.id,
          paginatedPage(_studentExamResultRespnonse?.studentsPaginateModel));
      final gradesRes = StudentExamResultRespnonse.fromJson(res);
      if (_studentExamResultRespnonse == null) {
        _studentExamResultRespnonse = gradesRes;
      } else {
        _studentExamResultRespnonse!.studentsPaginateModel
            .appendStudents(gradesRes.studentsPaginateModel);
      }
      emit(GetStudentGradesSuccessState());
    } catch (e) {
      emit(GetStudentGradesErrorState(error: e.toString()));
    }
  }

  Future<void> appendCollective(BuildContext context,
      {required Set<int> examIds,
      required String title,
      required DateTime date}) async {
    try {
      if (_stage == null) throw 'يجب اختيار المرحلة اولا';
      Methods.canCreatePermission(context.loggedInPermissions?.exams);

      emit(AddCollectiveExamLoadingState());
      await AppServices.collectiveExams(
          stageId: _stage!.id,
          examName: title,
          examDate: date,
          examIds: examIds);
      emit(AddCollectiveExamSuccessState());

      getStudentGrades();
    } catch (e) {
      emit(AddCollectiveExamErrorState(error: e.toString()));
    }
  }

  Future<void> addStudentGrade(BuildContext context, bool addNew, int studentId,
      int? groupId, num grade, ExamModel exam) async {
    try {
      emit(AddStudentGradeLoadingState());
      if (addNew) {
        Methods.canCreatePermission(context.loggedInPermissions?.grades);
      } else {
        Methods.canEditPermission(context.loggedInPermissions?.grades);
      }
      final res = await AppServices.storeGrade(
          examId: exam.id,
          grade: grade,
          studentId: studentId,
          groupId: groupId);
      final gradeModel = GradeModel.fromJson(res['grade']);
      _studentExamResultRespnonse?.setGrade(gradeModel);

      // students
      //     .firstWhere((element) => element.id == studentId)
      //     .grades
      //     ?.firstWhere((element) => element.examId == exam.id)
      //     .setGrade(grade);
      emit(AddStudentGradeSuccessState());
    } catch (e) {
      emit(AddStudentGradeErrorState(error: e.toString()));
      rethrow;
    }
  }

  //Student attendances
  StudentAttendanceRespnonse? _studentAttendanceRespnonse;
  bool get hasLoadedAttendancesRes => _studentAttendanceRespnonse != null;
  List<LectureModel> get allLectures =>
      _studentAttendanceRespnonse?.lectures ?? [];
  int? get totalAttendanceStudents =>
      _studentAttendanceRespnonse?.studentsPaginateModel.total_students;
  List<StudentModel> get allStudentAttendances =>
      _studentAttendanceRespnonse?.students ?? [];
  Future<void> getStudentAttendances() async {
    final time = DateTime.now();
    try {
      if (_stage == null) throw 'يجب اختيار المرحلة';

      _studentAttendanceRespnonse != null
          ? emit(GetMoreStudentLoadingState())
          : emit(GetStudentAttendancesLoadingState());
      final res = await AppServices.studentAttendances(_stage!.id,
          paginatedPage(_studentAttendanceRespnonse?.studentsPaginateModel));
      final attendanceRes = StudentAttendanceRespnonse.fromJson(res);
      // _studentAttendanceRespnonse = attendanceRes;
      if (_studentAttendanceRespnonse == null) {
        _studentAttendanceRespnonse = attendanceRes;
      } else {
        _studentAttendanceRespnonse!.appendStudents(attendanceRes);
      }
      log(DateTime.now().difference(time).inMilliseconds.toString());
      emit(GetStudentAttendancesSuccessState());
    } catch (e) {
      emit(GetStudentAttendancesErrorState(error: e.toString()));
      // rethrow;
    }
  }

  Future<void> attend(BuildContext context, bool addNew, String lectureId,
      AttendStatusEnum attendStatus, int? groupId) async {
    try {
      if (errorOnSearchedStudent) throw 'حدث خطأ اثناء تحضير الطالب';
      emit(AttendStudentLoadingState());
      if (attendStatus == AttendStatusEnum.cancel) {
        Methods.canDeletePermission(context.loggedInPermissions?.attendances);
      } else if (addNew) {
        Methods.canCreatePermission(context.loggedInPermissions?.attendances);
      } else {
        Methods.canEditPermission(context.loggedInPermissions?.attendances);
      }
      final res = await AppServices.storeAttendance(
        lectureId: lectureId,
        studentId: searchedStudent!.id.toString(),
        attend_status: attendStatus.getAttendStatusIndex,
        groupId: groupId,
      );
      if (res['attendance'] != null) {
        final attend = AttendanceModel.fromJson(res['attendance']);
        _studentAttendanceRespnonse?.setAttendance(attend);
      } else {
        _studentAttendanceRespnonse?.removeAttendance(
            searchedStudent!.id, int.parse(lectureId));
      }
      emit(AttendStudentSuccessState());
    } catch (e) {
      emit(AttendStudentErrorState(error: e.toString()));
    }
  }

  //Student homeworks
  StudentHomeworksResponse? _studentHomeworksResponse;
  bool get hasLoadedHomeworksRes => _studentHomeworksResponse != null;
  int? get totalHomeworkStudents =>
      _studentHomeworksResponse?.studentsPaginateModel.total_students;
  List<LectureModel> get allHomeworks =>
      _studentHomeworksResponse?.lectures ?? [];
  List<StudentModel> get allStudentHomeworks =>
      _studentHomeworksResponse?.students ?? [];

  Future<void> getStudentHomeworks() async {
    try {
      if (_stage == null) throw 'يجب اختيار المرحلة';
      _studentHomeworksResponse != null
          ? emit(GetMoreStudentLoadingState())
          : emit(GetStudentHomeworksLoadingState());
      final res = await AppServices.studentHomeworks(_stage!.id,
          paginatedPage(_studentHomeworksResponse?.studentsPaginateModel));
      final homeworks = StudentHomeworksResponse.fromJson(res);
      if (_studentHomeworksResponse == null) {
        _studentHomeworksResponse = homeworks;
      } else {
        _studentHomeworksResponse!.studentsPaginateModel
            .appendStudents(homeworks.studentsPaginateModel);
      }
      emit(GetStudentHomeworksSuccessState());
    } catch (e) {
      emit(GetStudentHomeworksErrorState(error: e.toString()));
      // rethrow;
    }
  }

  Future<void> addHomeWork(BuildContext context, bool addNew, String lectureId,
      HomeworkStatusEnum homeworkStatus) async {
    try {
      if (errorOnSearchedStudent) throw 'حدث خطأ اثناء تسجيل واجب الطالب';

      emit(AddHomeworkStudentLoadingState());
      if (addNew) {
        Methods.canCreatePermission(context.loggedInPermissions?.homeworks);
      } else {
        Methods.canEditPermission(context.loggedInPermissions?.homeworks);
      }
      final res = await AppServices.storeHomework(
          lectureId: lectureId,
          studentId: searchedStudent!.id.toString(),
          homework_status: homeworkStatus.getHomeworkStatusIndex);
      final homework = HomeworkModel.fromJson(res['homework']);
      _studentHomeworksResponse?.setHomework(homework);
      emit(AddHomeworkStudentSuccessState());
    } catch (e) {
      emit(AddHomeworkStudentErrorState(error: e.toString()));
    }
  }

  //Student homeworks
  StudentPaymentsResponse? _studentPaymentsResponse;
  bool get hasLoadedPaymentsRes => _studentPaymentsResponse != null;
  int? get totalPaymentStudents =>
      _studentPaymentsResponse?.studentsPaginateModel.total_students;
  List<PaymentsModel> get allPayments =>
      _studentPaymentsResponse?.payments ?? [];
  List<StudentModel> get allStudentPayments =>
      _studentPaymentsResponse?.students ?? [];

  Future<void> getStudentPayments() async {
    try {
      if (_stage == null) throw 'يجب اختيار المرحلة';
      _studentPaymentsResponse != null
          ? emit(GetMoreStudentLoadingState())
          : emit(GetStudentPaymentsLoadingState());
      final res = await AppServices.studentPayments(_stage!.id,
          paginatedPage(_studentPaymentsResponse?.studentsPaginateModel));
      final paymentRes = StudentPaymentsResponse.fromJson(res);
      if (_studentPaymentsResponse == null) {
        _studentPaymentsResponse = paymentRes;
      } else {
        _studentPaymentsResponse!.studentsPaginateModel
            .appendStudents(paymentRes.studentsPaginateModel);
      }
      emit(GetStudentPaymentsSuccessState());
    } catch (e) {
      emit(GetStudentPaymentsErrorState(error: e.toString()));
      // rethrow;
    }
  }

  Future<void> addPayment(BuildContext context, bool addNew, String paymentId,
      PaymentStatus paymentStatus) async {
    try {
      if (errorOnSearchedStudent) throw 'حدث خطأ اثناء تسجيل واجب الطالب';
      emit(AddPaymentLoadingState());
      if (addNew) {
        Methods.canCreatePermission(
            context.loggedInPermissions?.student_payments);
      } else {
        Methods.canEditPermission(
            context.loggedInPermissions?.student_payments);
      }
      final res = await AppServices.storeStudentPayment(
          payment_id: paymentId,
          student_id: searchedStudent!.id.toString(),
          payment_status: paymentStatus.getIndex);
      final payment = PaymentsModel.fromJson(res['payment']);
      _studentPaymentsResponse?.setPayment(payment);
      emit(AddPaymentSuccessState());
    } catch (e) {
      emit(AddPaymentErrorState(error: e.toString()));
    }
  }

  StudentModel? searchedStudent;
  bool get errorOnSearchedStudent => searchedStudent == null;
  void removeSearchedStudent() {
    searchedStudent = null;
  }

  Future<void> getStudentData(String? studentId, String? studentCode) async {
    try {
      emit(GetStudentDataLoadingState());
      final res = await AppServices.getStudentProfile(studentId, studentCode);

      emit(GetStudentDataSuccessState());
      searchedStudent = StudentModel.fromJson(res['student']);
    } catch (e) {
      emit(GetStudentDataErrorState(error: e.toString()));
      rethrow;
    }
  }

  Set<int> selectedIds = {};
  bool get selectedIdsContainData => selectedIds.isNotEmpty;
  void toggleSelectedId(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
      if (selectAllStudents) selectAllStudents = false;
    } else {
      selectedIds.add(id);
    }
    emit(ChangeSelectedIdStudentState(id));
  }

  bool selectAllStudents = false;
  void toggleSelectAllIds() {
    if (selectAllStudents) {
      selectedIds.clear();
    } else {
      selectedIds.clear();
      selectedIds = allStudentAttendances.map((e) => e.id).toSet();
    }
    selectAllStudents = !selectAllStudents;

    emit(SelectEraseAllStudentState());
  }

  StudentQrsResponse? qrsResponse;
  bool get hasQrError => qrsResponse == null;
  String get pdfPath => qrsResponse?.pdf_url ?? '';

  Future<void> generateQrs() async {
    try {
      emit(GenerateQrsLoadingState());
      final res = await AppServices.generateQrPdf(selectedIds.toList());
      qrsResponse = StudentQrsResponse.fromMap(res);
      emit(GenerateQrsSuccessState());
    } catch (e) {
      emit(GenerateQrsErrorState(error: e.toString()));
    }
  }

  Future<void> downloadStudentQrs() async {
    try {
      emit(DownloadStudentQrsLoadingState());
      // requests permission for downloading the file
      // bool hasPermission = await _requestWritePermission();
      // if (!hasPermission) throw 'ليس لديك صلاحيات للتحميل';

      // gets the directory where we will download the file.
      // var dir = await getApplicationDocumentsDirectory();
      final dir = await getExternalStorageDirectory();
      // await _prepareSaveDir();
      // final dir = _localPath;

      final pdfFilePath = "${dir!.path}/student_qr_codes.pdf";
      await Dio().download(pdfPath, pdfFilePath);
      OpenFile.open(pdfFilePath, type: 'application/pdf');

      emit(DownloadStudentQrsSuccessState());
    } catch (e) {
      emit(DownloadStudentQrsErrorState(error: e.toString()));
    }
  }

  // requests storage permission
  Future<bool> _requestWritePermission() async {
    if (await Permission.storage.isGranted) return true;
    //openAppSettings();
    // Request the permission
    final permissionStatus = await Permission.storage.request();

    // Log the permission status
    log(permissionStatus.toString());

    // Return whether the permission is granted
    return permissionStatus.isGranted;
  }
}
