import 'package:alqamar/models/attendance/attendance_model.dart';
import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/models/student/students_paginate_model.dart';

class StudentAttendanceRespnonse {
  final StudentsPaginateModel studentsPaginateModel;
  List<StudentModel> get students => studentsPaginateModel.students;
  final List<LectureModel> lectures;

  StudentAttendanceRespnonse({
    required this.studentsPaginateModel,
    required this.lectures,
  }) {
    _reAssign();
  }

  factory StudentAttendanceRespnonse.fromJson(Map<String, dynamic> map) {
    return StudentAttendanceRespnonse(
      lectures: List<LectureModel>.from(
          map['lectures']?.map((x) => LectureModel.fromJson(x))),
      studentsPaginateModel: StudentsPaginateModel.fromMap(map),
    );
  }
  void _reAssign() {
    for (var std in students) {
      List<AttendanceModel> allAttends = [];
      for (var lec in lectures) {
        final attendances = std.attendances;
        if (attendances != null) {
          final res =
              attendances.where((att) => att.lecId == lec.id).firstOrNull;
          if (res == null) {
            final attend = AttendanceModel(
              id: lec.id,
              attend_status: null,
              attendanceId: null,
              group: null,
              lecId: lec.id,
              lectureDate: lec.lectureDate,
              stageId: std.stageId,
              studentId: std.id,
              title: lec.title,
            );
            allAttends.add(attend);
          } else {
            allAttends.add(res);
          }
        }
      }
      std.attendances = allAttends;
    }
  }

  void setAttendance(AttendanceModel attendance) {
    int studentIndex =
        students.indexWhere((element) => element.id == attendance.studentId);
    if (studentIndex == -1) return;
    students[studentIndex].setAttendance(attendance);
  }

  void removeAttendance(int studentId, int lecId) {
    int studentIndex =
        students.indexWhere((element) => element.id == studentId);
    if (studentIndex == -1) return;
    int? lecIndex = students[studentIndex]
        .attendances
        ?.indexWhere((element) => element.lecId == lecId);
    if (lecIndex == -1 || lecIndex == null) return;
    students[studentIndex].attendances?[lecIndex].removeAttend();
  }

  void appendStudents(StudentAttendanceRespnonse other) {
    studentsPaginateModel.appendStudents(other.studentsPaginateModel);
  }
}
