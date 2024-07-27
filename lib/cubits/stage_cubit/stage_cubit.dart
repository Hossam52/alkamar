import 'package:alqamar/models/groups/group_model.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/shared/network/services/app_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import './stage_states.dart';

//Bloc builder and bloc consumer methods
typedef StageBlocBuilder = BlocBuilder<StageCubit, StageStates>;
typedef StageBlocConsumer = BlocConsumer<StageCubit, StageStates>;

//
class StageCubit extends Cubit<StageStates> {
  StageCubit() : super(IntitalStageState());
  static StageCubit instance(BuildContext context) =>
      BlocProvider.of<StageCubit>(context);
  late StageModel _stageModel;
  set setStage(StageModel stage) => _stageModel = stage;
  StageModel get stage => _stageModel;

  Future<void> createStudent({
    required String code,
    required String name,
    required String school,
    required String fatherPhone,
    required String motherPhone,
    required String studentPhone,
    required String whatsapp,
    required String address,
    required String gender,
    String problems = '',
    int? studentStatus,
    int? groupId,
  }) async {
    try {
      emit(CreateStudentLoadingState());
      await AppServices.createStudent(
        stageId: _stageModel.id,
        code: code,
        name: name,
        school: school,
        fatherPhone: fatherPhone,
        motherPhone: motherPhone,
        studentPhone: studentPhone,
        whatsapp: whatsapp,
        address: address,
        gender: gender,
        problems: problems,
        studentStatus: studentStatus,
        groupId: groupId,
      );
      emit(CreateStudentSuccessState());
    } catch (e) {
      emit(CreateStudentErrorState(error: e.toString()));
    }
  }

  Future<void> updateStudent({
    required int studentId,
    String? code,
    String? name,
    String? school,
    String? fatherPhone,
    String? motherPhone,
    String? studentPhone,
    String? whatsapp,
    String? address,
    String? problems,
    int? studentStatus,
    int? groupId,
  }) async {
    try {
      emit(UpdateStudentLoadingState());
      final res = await AppServices.updateStudent(
        studentId: studentId,
        code: code,
        name: name,
        school: school,
        fatherPhone: fatherPhone,
        motherPhone: motherPhone,
        studentPhone: studentPhone,
        whatsapp: whatsapp,
        address: address,
        problems: problems,
        studentStatus: studentStatus,
        groupId: groupId,
      );
      debugPrint(res.toString());
      final student = StudentModel.fromJson(res['student']);
      emit(UpdateStudentSuccessState(student));
    } catch (e) {
      emit(UpdateStudentErrorState(error: e.toString()));
    }
  }

  Future<void> createLecture(String name, DateTime? date) async {
    try {
      if (date == null) throw 'يجب اختيار تاريخ المحاضرة اولا';
      emit(CreateLectureLoadingState());
      await AppServices.storeLecture(
          stage_id: _stageModel.id, lectureName: name, lectureDate: date);
      emit(CreateLectureSuccessState());
    } catch (e) {
      emit(CreateLectureErrorState(error: e.toString()));
    }
  }

  Future<void> createPayment(String title, DateTime? date) async {
    try {
      if (date == null) throw 'يجب اختيار تاريخ المحاضرة اولا';
      emit(CreatePaymentLoadingState());
      await AppServices.storePayment(
          stage_id: _stageModel.id, title: title, paymentDate: date);
      emit(CreatePaymentSuccessState());
    } catch (e) {
      emit(CreatePaymentErrorState(error: e.toString()));
    }
  }

  Future<void> createExam(String title, String maxGrade, DateTime? date) async {
    try {
      if (date == null) throw 'يجب اختيار تاريخ الامتحان اولا';
      emit(CreateExamLoadingState());
      await AppServices.createExam(
          examDate: date,
          examName: title,
          stageId: _stageModel.id,
          maxGrade: maxGrade);
      emit(CreateExamSuccessState());
    } catch (e) {
      emit(CreateExamErrorState(error: e.toString()));
    }
  }

  GroupResponseModel? groupResponseModel;
  bool get errorOnGroups => groupResponseModel == null;
  List<GroupModel> get groups => groupResponseModel?.groups ?? [];
  Future<void> getGroups() async {
    try {
      emit(GetGroupsLoadingState());
      final res = await AppServices.allGroups(stageId: stage.id);
      groupResponseModel = GroupResponseModel.fromMap(res);
      emit(GetGroupsSuccessState());
    } catch (e) {
      emit(GetGroupsErrorState(error: e.toString()));
    }
  }

  Future<void> addGroup(String title) async {
    try {
      emit(AddGroupLoadingState());
      final res = await AppServices.addGroup(stageId: stage.id, title: title);
      final group = GroupModel.fromMap(res['group']);
      groupResponseModel?.appendGroup(group);
      emit(AddGroupSuccessState());
    } catch (e) {
      emit(AddGroupErrorState(error: e.toString()));
    }
  }

  Future<void> addEmptyStudents(int studentsCount) async {
    try {
      emit(AddEmptyStudentsLoadingState());
      final res = await AppServices.createEmptyStudents(
          stageId: stage.id, count: studentsCount);
      emit(AddEmptyStudentsSuccessState());
    } catch (e) {
      emit(AddEmptyStudentsErrorState(e.toString()));
    }
  }
}
