import 'package:alqamar/models/attendance/attendance_model.dart';
import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/models/homework/homework_model.dart';
import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/models/student/student_model.dart';

class StudentProfileResponse {
  StudentModel student;
  final List<GradeModel> grades;
  final List<AttendanceModel> attendance_late;
  final List<LectureModel> absence;
  final List<HomeworkModel> homeworks;

  StudentProfileResponse({
    required this.student,
    required this.grades,
    required this.attendance_late,
    required this.absence,
    required this.homeworks,
  });

  factory StudentProfileResponse.fromMap(Map<String, dynamic> map) {
    return StudentProfileResponse(
      student: StudentModel.fromJson(map['student']),
      grades: List<GradeModel>.from(
          map['grades']?.map((x) => GradeModel.fromJson(x))),
      attendance_late: List<AttendanceModel>.from(
          map['attendance_late']?.map((x) => AttendanceModel.fromJson(x))),
      absence: List<LectureModel>.from(
          map['absence']?.map((x) => LectureModel.fromJson(x))),
      homeworks: List<HomeworkModel>.from(
          map['homeworks']?.map((x) => HomeworkModel.fromJson(x))),
    );
  }

  String get generateWhatsappContent {
    String gradesText = grades.isEmpty
        ? 'لا يوجد درجات'
        : grades.map((e) => e.gradeContentReport).join('\n\n');
    String absenceText = absence.isEmpty
        ? 'لا يوجد غياب'
        : ('غاب الطالب عدد (${absence.length}) حصة وهي: \n') +
            absence
                .map((e) => e.getContentReport(name: 'غياب يوم '))
                .join('\n');
    String lateText = attendance_late.isEmpty
        ? 'لا يوجد تأخير'
        : ('تأخر الطالب عدد (${attendance_late.length}) حصة وهي: \n') +
            attendance_late.map((e) => e.getContentReport()).join('\n');
    String homeworkText = homeworks.isEmpty
        ? 'لا يوجد واجبات'
        : homeworks.map((e) => e.getContentReport()).join('\n');

    String text = '''

تقرير خاص بالطالب/ \n ${student.name}
📌 درجات الطالب 💪
$gradesText

📌 غياب الطالب 😠
$absenceText

📌 تأخير الطالب 😔
$lateText

📌 واجبات الطالب📝💪🏻
$homeworkText

${student.problems.isEmpty ? '' : '''
📌 مشاكل الطالب 😡
${student.problems}
'''}

وشكرا لحسن متابعتكم وتواصلكم معنا 😍💪🏻
🎖فريق عمل🎖
الأستاذ مصطفى قمر
 مدرس اللغة العربية

    ''';

    return text;
  }
}
