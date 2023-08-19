import 'package:alqamar/models/attend_status_enum.dart';
import 'package:alqamar/models/attendance/attendance_model.dart';
import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/models/homework/homework_model.dart';
import 'package:alqamar/models/homework_status_enum.dart';
import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/models/payments/payment_status_enum.dart';
import 'package:alqamar/models/payments/payments_model.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/models/student/student_qrs_response.dart';
import 'package:alqamar/shared/network/services/app_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  //Exam results
  StudentExamResultRespnonse? _studentExamResultRespnonse;
  bool get hasLoadedExamRes => _studentExamResultRespnonse != null;
  List<ExamModel> get allExams => _studentExamResultRespnonse?.exams ?? [];
  List<StudentModel> get allStudentGrades =>
      _studentExamResultRespnonse?.students ?? [];
  Future<void> getStudentGrades() async {
    try {
      if (_stage == null) throw 'يجب اختيار المرحلة';

      emit(GetStudentGradesLoadingState());
      final res = await AppServices.listStudents(_stage!.id);
      _studentExamResultRespnonse = StudentExamResultRespnonse.fromJson(res);
      emit(GetStudentGradesSuccessState());
    } catch (e) {
      emit(GetStudentGradesErrorState(error: e.toString()));
    }
  }

  Future<void> appendCollective(
      {required Set<int> examIds,
      required String title,
      required DateTime date}) async {
    try {
      if (_stage == null) throw 'يجب اختيار المرحلة اولا';
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

  Future<void> addStudentGrade(int studentId, num grade, ExamModel exam) async {
    try {
      emit(AddStudentGradeLoadingState());
      await AppServices.storeGrade(
          examId: exam.id, grade: grade, studentId: studentId);
      _studentExamResultRespnonse?.students
          .firstWhere((element) => element.id == studentId)
          .grades
          ?.firstWhere((element) => element.id == exam.id)
          .setGrade(grade);
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
  List<StudentModel> get allStudentAttendances =>
      _studentAttendanceRespnonse?.students ?? [];

  Future<void> getStudentAttendances() async {
    try {
      if (_stage == null) throw 'يجب اختيار المرحلة';
      emit(GetStudentAttendancesLoadingState());
      final res = await AppServices.studentAttendances(_stage!.id);
      _studentAttendanceRespnonse = StudentAttendanceRespnonse.fromJson(res);
      emit(GetStudentAttendancesSuccessState());
    } catch (e) {
      emit(GetStudentAttendancesErrorState(error: e.toString()));
      // rethrow;
    }
  }

  Future<void> attend(
      String lectureId, AttendStatusEnum attendStatusEnum) async {
    _attendStudent(lectureId, attendStatusEnum.getAttendStatusIndex);
  }

  Future<void> _attendStudent(String lectureId, int? attendStatus) async {
    try {
      if (errorOnSearchedStudent) throw 'حدث خطأ اثناء تحضير الطالب';
      emit(AttendStudentLoadingState());
      final res = await AppServices.storeAttendance(
          lectureId: lectureId,
          studentId: searchedStudent!.id.toString(),
          attend_status: attendStatus);
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
  List<LectureModel> get allHomeworks =>
      _studentHomeworksResponse?.lectures ?? [];
  List<StudentModel> get allStudentHomeworks =>
      _studentHomeworksResponse?.students ?? [];

  Future<void> getStudentHomeworks() async {
    try {
      if (_stage == null) throw 'يجب اختيار المرحلة';
      emit(GetStudentHomeworksLoadingState());
      final res = await AppServices.studentHomeworks(_stage!.id);
      _studentHomeworksResponse = StudentHomeworksResponse.fromJson(res);
      emit(GetStudentHomeworksSuccessState());
    } catch (e) {
      emit(GetStudentHomeworksErrorState(error: e.toString()));
      // rethrow;
    }
  }

  Future<void> addHomeWork(
      String lectureId, HomeworkStatusEnum homeworkStatus) async {
    _addStudentHomework(lectureId, homeworkStatus.getHomeworkStatusIndex);
  }

  Future<void> _addStudentHomework(String lectureId, int homeworkStatus) async {
    try {
      if (errorOnSearchedStudent) throw 'حدث خطأ اثناء تسجيل واجب الطالب';
      emit(AddHomeworkStudentLoadingState());
      final res = await AppServices.storeHomework(
          lectureId: lectureId,
          studentId: searchedStudent!.id.toString(),
          homework_status: homeworkStatus);
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
  List<PaymentsModel> get allPayments =>
      _studentPaymentsResponse?.payments ?? [];
  List<StudentModel> get allStudentPayments =>
      _studentPaymentsResponse?.students ?? [];

  Future<void> getStudentPayments() async {
    try {
      if (_stage == null) throw 'يجب اختيار المرحلة';
      emit(GetStudentPaymentsLoadingState());
      final res = await AppServices.studentPayments(_stage!.id);
      _studentPaymentsResponse = StudentPaymentsResponse.fromJson(res);
      emit(GetStudentPaymentsSuccessState());
    } catch (e) {
      emit(GetStudentPaymentsErrorState(error: e.toString()));
      // rethrow;
    }
  }

  Future<void> addPayment(String paymentId, PaymentStatus paymentStatus) async {
    try {
      if (errorOnSearchedStudent) throw 'حدث خطأ اثناء تسجيل واجب الطالب';
      emit(AddPaymentLoadingState());
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
      bool hasPermission = await _requestWritePermission();
      if (!hasPermission) return;

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
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }
}
