import 'package:alqamar/models/homework_status_enum.dart';
import 'package:alqamar/shared/methods.dart';

class HomeworkModel {
  int id;
  int stageId;
  String title;
  String lectureDate;
  DateTime date;
  int? attendanceId;
  int? studentId;
  int? homework_status; //1 done 2 incomplete 3 not done
  HomeworkStatusEnum homeworkStatusEnum;
  int? lecId;

  HomeworkModel({
    required this.id,
    required this.stageId,
    required this.title,
    required this.lectureDate,
    required this.attendanceId,
    required this.studentId,
    required this.homework_status,
    required this.lecId,
  })  : date = DateTime.parse(lectureDate),
        homeworkStatusEnum = HomeworkStatusMethods.getHomework(homework_status);

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    return HomeworkModel(
      id: json['id'],
      stageId: json['stage_id'],
      title: json['title'],
      lectureDate: json['lecture_date'],
      attendanceId: json['attendance_id'],
      studentId: json['student_id'],
      homework_status: json['homework_status'],
      lecId: json['lec_id'],
    );
  }
  bool get hasMakeHomework =>
      homeworkStatusEnum != HomeworkStatusEnum.undefined;
  bool get getIsDone => homeworkStatusEnum == HomeworkStatusEnum.done;

  String getContentReport({String name = ''}) {
    String text = '''
\t\t - $name $title \t (${Methods.formatDate(date)}) \t ${homeworkStatusEnum.getHomeworkText}
''';
    return text;
  }
}
