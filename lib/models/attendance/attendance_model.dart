import 'package:alqamar/models/attend_status_enum.dart';
import 'package:alqamar/models/groups/group_model.dart';
import 'package:alqamar/shared/methods.dart';

class AttendanceModel {
  int id;
  int stageId;
  String title;
  String lectureDate;
  DateTime date;
  int? attendanceId;
  int? studentId;
  int? attend_status; //1 attend 2 late 3 forgot book
  AttendStatusEnum attendStatusEnum;
  int? lecId;
  GroupModel? group;

  AttendanceModel({
    required this.id,
    required this.stageId,
    required this.title,
    required this.lectureDate,
    required this.attendanceId,
    required this.studentId,
    required this.attend_status,
    required this.lecId,
    required this.group,
  })  : date = DateTime.parse(lectureDate),
        attendStatusEnum = AttendStatusMethods.getAttend(attend_status);

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      stageId: json['stage_id'],
      title: json['title'],
      lectureDate: json['lecture_date'],
      attendanceId: json['attendance_id'],
      studentId: json['student_id'],
      attend_status: json['attend_status'],
      lecId: json['lec_id'],
      group: json['group'] == null ? null : GroupModel.fromMap(json['group']),
    );
  }
  bool get hasAttended => attendStatusEnum != AttendStatusEnum.undefined;
  bool get getIsLate => attendStatusEnum == AttendStatusEnum.late;
  void removeAttend() {
    attendanceId = studentId = attend_status = lecId = group = null;
    attendStatusEnum = AttendStatusEnum.undefined;
  }

  String getContentReport({String name = ''}) {
    String text = '''
\t\t - $name $title \t (${Methods.formatDate(date)}) \t ${attendStatusEnum.getAttendanceText}
''';
    return text;
  }
}
