import 'package:alqamar/models/student/student_model.dart';

class StudentsPaginateModel {
  int page = 2;
  final int total_students;

  final bool status;
  final List<StudentModel> students;

  StudentsPaginateModel({
    required this.status,
    required this.students,
    required this.total_students,
  });

  factory StudentsPaginateModel.fromMap(Map<String, dynamic> map) {
    return StudentsPaginateModel(
      status: map['status'] ?? false,
      students: List<StudentModel>.from(
          map['students']?.map((x) => StudentModel.fromJson(x))),
      total_students: map['total_students'] ?? 0,
    );
  }

  void appendStudents(StudentsPaginateModel other) {
    if (other.students.isNotEmpty) {
      students.addAll(other.students);
      page++;
    }
  }
}
