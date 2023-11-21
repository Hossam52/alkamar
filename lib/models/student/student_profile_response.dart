import 'package:alqamar/config/date_formatter_extension.dart';
import 'package:alqamar/models/attendance/attendance_model.dart';
import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/models/homework/homework_model.dart';
import 'package:alqamar/models/homework_status_enum.dart';
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

  String generateWhatsappContent(
      {required DateTime from, required DateTime to}) {
    final absenceFiltered = absence
        .where((element) =>
            element.date.isAfter(from) && element.date.isBefore(to))
        .toList();
    final lateFiltered = attendance_late
        .where((element) =>
            element.date.isAfter(from) && element.date.isBefore(to))
        .toList();
    final homeworkFiltered = homeworks
        .where((element) =>
            element.date.isAfter(from) && element.date.isBefore(to))
        .toList();
    final gradesFiltered = grades
        .where((grade) =>
            grade.examDate.isAfter(from) && grade.examDate.isBefore(to))
        .toList();
    String gradesText = gradesFiltered.isEmpty
        ? 'لا يوجد درجات'
        : gradesFiltered.map((e) => e.gradeContentReport).join('\n\n');
    String absenceText = absenceFiltered.isEmpty
        ? 'لا يوجد غياب'
        : ('غاب الطالب عدد (${absenceFiltered.length}) حصة وهي: \n') +
            absenceFiltered
                .map((e) => e.getContentReport(name: 'غياب يوم '))
                .join('\n');
    String lateText = lateFiltered.isEmpty
        ? 'لا يوجد تأخير'
        : ('تأخر الطالب عدد (${lateFiltered.length}) حصة وهي: \n') +
            lateFiltered.map((e) => e.getContentReport()).join('\n');
    final homeowrksWithoutDone = homeworkFiltered.where(
        (element) => element.homeworkStatusEnum != HomeworkStatusEnum.done);
    String homeworkText = homeworkFiltered.isEmpty
        ? 'لا يوجد واجبات'
        : 'منتظم في عمل الواجبات ${homeowrksWithoutDone.isEmpty ? '' : 'ماعدا:\n'} ${homeowrksWithoutDone.map((e) => e.getContentReport()).join('\n')}';

    String text = '''

تقرير خاص بالطالب/ \n ${student.name} من ${from.formatDate()} إلي ${to.formatDate()}
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
