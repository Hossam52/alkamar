//
abstract class StudentStates {}

class IntitalStudentState extends StudentStates {}
//

//GetStudentGrades online fetch data
class GetStudentGradesLoadingState extends StudentStates {}

class GetStudentGradesSuccessState extends StudentStates {}

class GetStudentGradesErrorState extends StudentStates {
  final String error;
  GetStudentGradesErrorState({required this.error});
}

//AddStudentGrade online fetch data
class AddStudentGradeLoadingState extends StudentStates {}

class AddStudentGradeSuccessState extends StudentStates {}

class AddStudentGradeErrorState extends StudentStates {
  final String error;
  AddStudentGradeErrorState({required this.error});
}

//GetStudentAttendances online fetch data
class GetStudentAttendancesLoadingState extends StudentStates {}

class GetStudentAttendancesSuccessState extends StudentStates {}

class GetMoreStudentLoadingState extends StudentStates {}

class GetStudentAttendancesErrorState extends StudentStates {
  final String error;
  GetStudentAttendancesErrorState({required this.error});
}

//AttendStudent online fetch data
class AttendStudentLoadingState extends StudentStates {}

class AttendStudentSuccessState extends StudentStates {}

class AttendStudentErrorState extends StudentStates {
  final String error;
  AttendStudentErrorState({required this.error});
}

//GetStudentAttendances online fetch data
class GetStudentHomeworksLoadingState extends StudentStates {}

class GetStudentHomeworksSuccessState extends StudentStates {}

class GetStudentHomeworksErrorState extends StudentStates {
  final String error;
  GetStudentHomeworksErrorState({required this.error});
}

//GetStudentPayments online fetch data
class GetStudentPaymentsLoadingState extends StudentStates {}

class GetStudentPaymentsSuccessState extends StudentStates {}

class GetStudentPaymentsErrorState extends StudentStates {
  final String error;
  GetStudentPaymentsErrorState({required this.error});
}

//AddPayment online fetch data
class AddPaymentLoadingState extends StudentStates {}

class AddPaymentSuccessState extends StudentStates {}

class AddPaymentErrorState extends StudentStates {
  final String error;
  AddPaymentErrorState({required this.error});
}

//AttendStudent online fetch data
class AddHomeworkStudentLoadingState extends StudentStates {}

class AddHomeworkStudentSuccessState extends StudentStates {}

class AddHomeworkStudentErrorState extends StudentStates {
  final String error;
  AddHomeworkStudentErrorState({required this.error});
}

//GetStudentData online fetch data
class GetStudentDataLoadingState extends StudentStates {}

class GetStudentDataSuccessState extends StudentStates {}

class GetStudentDataErrorState extends StudentStates {
  final String error;
  GetStudentDataErrorState({required this.error});
}

//GetStudentProfile online fetch data
class GetStudentProfileLoadingState extends StudentStates {}

class GetStudentProfileSuccessState extends StudentStates {}

class GetStudentProfileErrorState extends StudentStates {
  final String error;
  GetStudentProfileErrorState({required this.error});
}

//GenerateQrs online fetch data
class GenerateQrsLoadingState extends StudentStates {}

class GenerateQrsSuccessState extends StudentStates {}

class GenerateQrsErrorState extends StudentStates {
  final String error;
  GenerateQrsErrorState({required this.error});
}

//DownloadStudentQrs online fetch data
class DownloadStudentQrsLoadingState extends StudentStates {}

class DownloadStudentQrsSuccessState extends StudentStates {}

class DownloadStudentQrsErrorState extends StudentStates {
  final String error;
  DownloadStudentQrsErrorState({required this.error});
}

class ChangeSelectedIdStudentState extends StudentStates {
  final int id;

  ChangeSelectedIdStudentState(this.id);
}

class SelectEraseAllStudentState extends StudentStates {}

class UpdateStudentState extends StudentStates {}

//AddCollectiveExam online fetch data
class AddCollectiveExamLoadingState extends StudentStates {}

class AddCollectiveExamSuccessState extends StudentStates {}

class AddCollectiveExamErrorState extends StudentStates {
  final String error;
  AddCollectiveExamErrorState({required this.error});
}
