//
abstract class ExamStates {}

class IntitalExamState extends ExamStates {}

//
//GetExamStatistics online fetch data
class GetExamStatisticsLoadingState extends ExamStates {}

class GetExamStatisticsSuccessState extends ExamStates {}

class GetExamStatisticsErrorState extends ExamStates {
  final String error;
  GetExamStatisticsErrorState({required this.error});
}

//UpdateExam online fetch data
class UpdateExamLoadingState extends ExamStates {}

class UpdateExamSuccessState extends ExamStates {}

class UpdateExamErrorState extends ExamStates {
  final String error;
  UpdateExamErrorState({required this.error});
}

//DeleteExam online fetch data
class DeleteExamLoadingState extends ExamStates {}

class DeleteExamSuccessState extends ExamStates {}

class DeleteExamErrorState extends ExamStates {
  final String error;
  DeleteExamErrorState({required this.error});
}
