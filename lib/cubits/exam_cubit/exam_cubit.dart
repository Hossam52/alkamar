import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/models/exam/exam_statistics_model.dart';
import 'package:alqamar/shared/network/services/app_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import './exam_states.dart';

//Bloc builder and bloc consumer methods
typedef ExamBlocBuilder = BlocBuilder<ExamCubit, ExamStates>;
typedef ExamBlocConsumer = BlocConsumer<ExamCubit, ExamStates>;

//
class ExamCubit extends Cubit<ExamStates> {
  ExamCubit(this.exam) : super(IntitalExamState());
  static ExamCubit instance(BuildContext context) =>
      BlocProvider.of<ExamCubit>(context);
  ExamModel exam;

  ExamStatisticesResponse? _examStats;
  bool get errorLoadingStats => _examStats == null;
  List<ExamStatsModel> get examStatistics => _examStats?.stats ?? [];
  int get examAbsenceCount => _examStats?.examAbsenceCount ?? 0;
  int get examTotalStudentsCount => _examStats?.total_students_count ?? 0;
  Future<void> getExamStatistics({String? division, int? groupId}) async {
    try {
      emit(GetExamStatisticsLoadingState());
      final response = await AppServices.getExamStats(exam.id,
          division: division, groupId: groupId);
      _examStats = ExamStatisticesResponse.fromMap(response);
      emit(GetExamStatisticsSuccessState());
    } catch (e) {
      emit(GetExamStatisticsErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<void> updateExam(
      {String? examName, num? maxGrade, DateTime? examDate}) async {
    try {
      emit(UpdateExamLoadingState());
      final res = await AppServices.updateExam(
          examId: exam.id,
          examName: examName,
          maxGrade: maxGrade,
          examDate: examDate);
      final examModel = ExamModel.fromJson(res['exam']);
      exam = examModel;
      emit(UpdateExamSuccessState());
    } catch (e) {
      emit(UpdateExamErrorState(error: e.toString()));
    }
  }

  Future<void> deleteExam() async {
    try {
      emit(DeleteExamLoadingState());
      await AppServices.deleteExam(examId: exam.id);
      emit(DeleteExamSuccessState());
    } catch (e) {
      emit(DeleteExamErrorState(error: e.toString()));
    }
  }
}
