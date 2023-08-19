//
abstract class LectureStates {}

class IntitalLectureState extends LectureStates {}

//
//GetLectureStatistics online fetch data
class GetLectureStatisticsLoadingState extends LectureStates {}

class GetLectureStatisticsSuccessState extends LectureStates {}

class GetLectureStatisticsErrorState extends LectureStates {
  final String error;
  GetLectureStatisticsErrorState({required this.error});
}

//UpdateLecture online fetch data
class UpdateLectureLoadingState extends LectureStates {}

class UpdateLectureSuccessState extends LectureStates {}

class UpdateLectureErrorState extends LectureStates {
  final String error;
  UpdateLectureErrorState({required this.error});
}

//DeleteLecture online fetch data
class DeleteLectureLoadingState extends LectureStates {}

class DeleteLectureSuccessState extends LectureStates {}

class DeleteLectureErrorState extends LectureStates {
  final String error;
  DeleteLectureErrorState({required this.error});
}
