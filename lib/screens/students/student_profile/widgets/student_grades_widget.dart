import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_profile_base_section.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/custom_table_defination_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class StudentGrades extends StatelessWidget {
  const StudentGrades({
    super.key,
    required this.grades,
  });

  final List<GradeModel> grades;

  @override
  Widget build(BuildContext context) {
    return StudentProfileBaseSection(
      title: 'درجات الطالب',
      child: Builder(
        builder: (context) {
          if (grades.isEmpty) {
            return const Center(
              child: TextWidget(label: 'لا يوجد درجات'),
            );
          }
          return CustomTableDefinition(
              tableDefinition: TableDefinition(
                  headers: ['الامتحان', 'التاريخ', 'الدرجة'],
                  rows: grades
                      .map((grade) => RowItem(
                              color: grade.generateColor,
                              cells: [
                                grade.title,
                                Methods.formatDate(grade.examDate),
                                grade.gradeFromMaxGrade
                              ]))
                      .toList()));
        },
      ),
    );
  }
}
