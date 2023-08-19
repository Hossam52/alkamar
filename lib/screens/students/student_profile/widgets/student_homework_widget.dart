import 'package:alqamar/models/homework/homework_model.dart';
import 'package:alqamar/models/homework_status_enum.dart';
import 'package:alqamar/screens/students/student_profile/widgets/lecture_base_section.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_profile_base_section.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/custom_table_defination_widget.dart';
import 'package:flutter/material.dart';

class StudentHomework extends StatelessWidget {
  const StudentHomework({
    super.key,
    required this.homeworks,
  });

  final List<HomeworkModel> homeworks;

  @override
  Widget build(BuildContext context) {
    return StudentProfileBaseSection(
      title: 'واجبات الطالب',
      child: StudentLectureBase(
        tableDefinition: TableDefinition(
            headers: ['المحاضرة', 'التاريخ', 'الواجب'],
            rows: homeworks
                .map((e) => RowItem(cells: [
                      e.title,
                      Methods.formatDate(e.date),
                      e.homeworkStatusEnum.getHomeworkText
                    ], color: e.homeworkStatusEnum.getHomeworkColor))
                .toList()),
        data: 'واجبات',
      ),
    );
  }
}
