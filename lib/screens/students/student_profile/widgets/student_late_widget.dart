import 'package:alqamar/models/attendance/attendance_model.dart';
import 'package:alqamar/screens/students/student_profile/widgets/lecture_base_section.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_profile_base_section.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/custom_table_defination_widget.dart';
import 'package:flutter/material.dart';

class StudentLate extends StatelessWidget {
  const StudentLate({
    super.key,
    required this.late,
  });

  final List<AttendanceModel> late;

  @override
  Widget build(BuildContext context) {
    return StudentProfileBaseSection(
        title: 'تأخير الطالب',
        child: StudentLectureBase(
          tableDefinition: TableDefinition(
              headers: ['المحاضرة', 'التاريخ'],
              rows: late
                  .map((e) => RowItem(
                        cells: [e.title, Methods.formatDate(e.date)],
                      ))
                  .toList()),
          data: 'تأخير',
        ));
  }
}
