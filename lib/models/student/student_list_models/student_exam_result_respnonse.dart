import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/models/student/students_paginate_model.dart';

class StudentExamResultRespnonse {
  final StudentsPaginateModel studentsPaginateModel;
  List<StudentModel> get students => studentsPaginateModel.students;
  final List<ExamModel> exams;

  StudentExamResultRespnonse(
      {required this.studentsPaginateModel, required this.exams}) {
    _reAssign();
  }

  factory StudentExamResultRespnonse.fromJson(Map<String, dynamic> map) {
    return StudentExamResultRespnonse(
      exams:
          List<ExamModel>.from(map['exams']?.map((x) => ExamModel.fromJson(x))),
      studentsPaginateModel: StudentsPaginateModel.fromMap(map),
    );
  }
  void _reAssign() {
    for (var std in students) {
      List<GradeModel> allGrades = [];
      for (var exam in exams) {
        final grades = std.grades;
        if (grades != null) {
          final res =
              grades.where((grade) => grade.examId == exam.id).firstOrNull;
          if (res == null) {
            final grade = GradeModel(
              id: exam.id,
              stageId: exam.stageId,
              title: exam.title,
              maxGrade: exam.maxGrade,
              examDate: exam.date,
            );
            allGrades.add(grade);
          } else {
            allGrades.add(res);
          }
        }
      }
      std.grades = allGrades;
    }
  }

  //For append collective exams
  StudentExamResultRespnonse appendCollectiveExams(Set<int> examIds) {
    final examList =
        exams.where((element) => examIds.contains(element.id)).toList();
    int totalGrade = 0;
    for (var element in examList) {
      totalGrade += element.maxGrade;
    }
    final ExamModel ex = ExamModel(
        id: 0,
        withoutInteract: true,
        stageId: exams[0].stageId,
        title: 'مجمع',
        maxGrade: totalGrade,
        examDate: DateTime.now().toIso8601String());

    exams.add(ex);
    for (int i = 0; i < students.length; i++) {
      double totalGrades = 0;
      for (var exam in examList) {
        totalGrades += students[i].getGradeByExamId(exam.id);
      }
      students[i].appendGradeModel(ex, totalGrades);
    }
    return this;
  }
}
