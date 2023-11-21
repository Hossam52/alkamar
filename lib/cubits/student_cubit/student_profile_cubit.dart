import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/attendance/attendance_model.dart';
import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/models/homework/homework_model.dart';
import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/models/student/student_profile_response.dart';
import 'package:alqamar/shared/network/services/app_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

//Bloc builder and bloc consumer methods
typedef StudentProfileBlocBuilder
    = BlocBuilder<StudentProfileCubit, StudentStates>;
typedef StudentProfileBlocConsumer
    = BlocConsumer<StudentProfileCubit, StudentStates>;

//
class StudentProfileCubit extends StudentCubit {
  StudentProfileCubit(this._studentId) : super(StageModel.empty());
  static StudentProfileCubit instance(BuildContext context) =>
      BlocProvider.of<StudentProfileCubit>(context);

  final int _studentId;

  StudentProfileResponse? _profileResponse;
  String whtasappContent(DateTime from, DateTime to) =>
      _profileResponse?.generateWhatsappContent(from: from, to: to) ?? '';
  StudentModel get student => _profileResponse!.student;
  set setStudent(StudentModel st) {
    _profileResponse!.student = st;
    emit(UpdateStudentState());
  }

  List<LectureModel> get absence => _profileResponse?.absence ?? [];
  List<AttendanceModel> get late => _profileResponse?.attendance_late ?? [];
  List<GradeModel> get grades => _profileResponse?.grades ?? [];
  List<HomeworkModel> get homeworks => _profileResponse?.homeworks ?? [];

  bool get profileError => _profileResponse == null;
  Future<void> getStudentProfile() async {
    try {
      emit(GetStudentProfileLoadingState());
      final res = await AppServices.getStudentData(_studentId.toString());
      _profileResponse = StudentProfileResponse.fromMap(res);
      emit(GetStudentProfileSuccessState());
    } catch (e) {
      emit(GetStudentProfileErrorState(error: e.toString()));
    }
  }
}
