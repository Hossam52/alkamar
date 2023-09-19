import 'package:alqamar/models/homework/homework_model.dart';
import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/models/student/students_paginate_model.dart';

class StudentHomeworksResponse {
  final StudentsPaginateModel studentsPaginateModel;
  List<StudentModel> get students => studentsPaginateModel.students;
  final List<LectureModel> lectures;

  StudentHomeworksResponse(
      {required this.studentsPaginateModel, required this.lectures}) {
    _reAssign();
  }

  factory StudentHomeworksResponse.fromJson(Map<String, dynamic> map) {
    return StudentHomeworksResponse(
      studentsPaginateModel: StudentsPaginateModel.fromMap(map),
      lectures: List<LectureModel>.from(
          map['lectures']?.map((x) => LectureModel.fromJson(x))),
    );
  }
  void _reAssign() {
    for (var std in students) {
      List<HomeworkModel> allHomeworks = [];
      for (var lec in lectures) {
        final homeworks = std.homeworks;
        if (homeworks != null) {
          final res = homeworks.where((att) => att.lecId == lec.id).firstOrNull;
          if (res == null) {
            final homework = HomeworkModel(
              id: lec.id,
              attendanceId: null,
              lecId: lec.id,
              lectureDate: lec.lectureDate,
              stageId: std.stageId,
              studentId: std.id,
              title: lec.title,
              homework_status: null,
            );
            allHomeworks.add(homework);
          } else {
            allHomeworks.add(res);
          }
        }
      }
      std.homeworks = allHomeworks;
    }
  }

  void setHomework(HomeworkModel homework) {
    int studentIndex =
        students.indexWhere((element) => element.id == homework.studentId);
    if (studentIndex == -1) return;
    students[studentIndex].setHomework(homework);
  }
}
