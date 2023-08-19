import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/models/lecture/lecture_statistics_model.dart';
import 'package:alqamar/shared/network/services/app_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'lecture_states.dart';

//Bloc builder and bloc consumer methods
typedef LectureBlocBuilder = BlocBuilder<LectureCubit, LectureStates>;
typedef LectureBlocConsumer = BlocConsumer<LectureCubit, LectureStates>;

//
class LectureCubit extends Cubit<LectureStates> {
  LectureCubit(this.lecture) : super(IntitalLectureState());
  static LectureCubit instance(BuildContext context) =>
      BlocProvider.of<LectureCubit>(context);
  LectureModel lecture;

  LectureStatisticsResponse? _lectureStats;
  bool get errorLoadingStats => _lectureStats == null;
  int get totalAttendances => _lectureStats?.total_attendance_count ?? 0;
  int get totalLateCount => _lectureStats?.late_count ?? 0;
  int get totalForgotCount => _lectureStats?.forgot_book_count ?? 0;
  int get totalAttendCount => _lectureStats?.attends_count ?? 0;
  int get totalAbsence => _lectureStats?.absence_count ?? 0;
  int get totalStudents => _lectureStats?.students_count ?? 0;
  int get totalDisalbed => _lectureStats?.disabled_count ?? 0;
  Future<void> getLectureStatistics() async {
    try {
      emit(GetLectureStatisticsLoadingState());
      final response = await AppServices.lectureStats(lecture_id: lecture.id);
      _lectureStats = LectureStatisticsResponse.fromMap(response);
      emit(GetLectureStatisticsSuccessState());
    } catch (e) {
      emit(GetLectureStatisticsErrorState(error: e.toString()));
    }
  }

  Future<void> updateLecture({String? title, DateTime? date}) async {
    try {
      emit(UpdateLectureLoadingState());
      final res = await AppServices.updateLecture(
          lectureId: lecture.id, lectureName: title, lectureDate: date);
      lecture = LectureModel.fromJson(res['lecture']);
      emit(UpdateLectureSuccessState());
    } catch (e) {
      emit(UpdateLectureErrorState(error: e.toString()));
    }
  }

  Future<void> deleteLecture() async {
    try {
      emit(DeleteLectureLoadingState());
      await AppServices.deleteLecture(lectureId: lecture.id);
      emit(DeleteLectureSuccessState());
    } catch (e) {
      emit(DeleteLectureErrorState(error: e.toString()));
    }
  }
}
