import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/models/student/student_model.dart';

class ExamStatisticesResponse {
  final bool status;
  final String message;
  final int examAbsenceCount;
  final int total_students_count;
  final List<ExamStatsModel> stats;
  ExamStatisticesResponse({
    required this.status,
    required this.message,
    required this.examAbsenceCount,
    required this.total_students_count,
    required this.stats,
  });
  factory ExamStatisticesResponse.fromMap(Map<String, dynamic> map) {
    return ExamStatisticesResponse(
      status: map['status'] ?? false,
      message: map['message'] ?? '',
      examAbsenceCount: map['exam_absence_count']?.toInt() ?? 0,
      total_students_count: map['total_students_count']?.toInt() ?? 0,
      stats: List<ExamStatsModel>.from(
          map['stats']?.map((x) => ExamStatsModel.fromMap(x))),
    );
  }
}

class ExamStatsModel {
  final int from;
  final int to;
  final List<StudentGrades> students;
  ExamStatsModel({
    required this.from,
    required this.to,
    required this.students,
  });

  factory ExamStatsModel.fromMap(Map<String, dynamic> map) {
    return ExamStatsModel(
      from: map['from']?.toInt() ?? 0,
      to: map['to']?.toInt() ?? 0,
      students: List<StudentGrades>.from(
          map['students']?.map((x) => StudentGrades.fromMap(x))),
    );
  }
}

class StudentGrades {
  final StudentModel student;
  final GradeModel grade;
  StudentGrades({
    required this.student,
    required this.grade,
  });

  factory StudentGrades.fromMap(Map<String, dynamic> map) {
    return StudentGrades(
      student: StudentModel.fromJson(map['student']),
      grade: GradeModel.fromJson(map['grade']),
    );
  }
}
