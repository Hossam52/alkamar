import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/screens/students/student_profile/widgets/lecture_base_section.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_profile_base_section.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/custom_table_defination_widget.dart';
import 'package:flutter/material.dart';

class StudentAbsence extends StatelessWidget {
  const StudentAbsence({
    super.key,
    required this.absence,
  });

  final List<LectureModel> absence;

  @override
  Widget build(BuildContext context) {
    return StudentProfileBaseSection(
      title: 'غياب الطالب',
      child: StudentLectureBase(
        tableDefinition: TableDefinition(
            headers: ['المحاضرة', 'التاريخ'],
            rows: absence
                .map((e) => RowItem(
                      cells: [e.title, Methods.formatDate(e.date)],
                    ))
                .toList()),
        data: 'غياب',
      ),
    );
  }
}
