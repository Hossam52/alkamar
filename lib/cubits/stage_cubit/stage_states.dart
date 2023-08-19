//
import 'package:alqamar/models/student/student_model.dart';

abstract class StageStates {}

class IntitalStageState extends StageStates {}

//
//CreateStudent online fetch data
class CreateStudentLoadingState extends StageStates {}

class CreateStudentSuccessState extends StageStates {}

class CreateStudentErrorState extends StageStates {
  final String error;
  CreateStudentErrorState({required this.error});
}

//UpdateStudent online fetch data
class UpdateStudentLoadingState extends StageStates {}

class UpdateStudentSuccessState extends StageStates {
  final StudentModel student;

  UpdateStudentSuccessState(this.student);
}

class UpdateStudentErrorState extends StageStates {
  final String error;
  UpdateStudentErrorState({required this.error});
}

//CreateLecture online fetch data
class CreateLectureLoadingState extends StageStates {}

class CreateLectureSuccessState extends StageStates {}

class CreateLectureErrorState extends StageStates {
  final String error;
  CreateLectureErrorState({required this.error});
}

//CreateExam online fetch data
class CreateExamLoadingState extends StageStates {}

class CreateExamSuccessState extends StageStates {}

class CreateExamErrorState extends StageStates {
  final String error;
  CreateExamErrorState({required this.error});
}

//CreatePayment online fetch data
class CreatePaymentLoadingState extends StageStates {}

class CreatePaymentSuccessState extends StageStates {}

class CreatePaymentErrorState extends StageStates {
  final String error;
  CreatePaymentErrorState({required this.error});
}
