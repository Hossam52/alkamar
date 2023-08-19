import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/screens/statistics/exam_statistics_screen.dart';
import 'package:alqamar/screens/students/student_exams/widgets/grade_dialog.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_data.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamGradesTable extends StatefulWidget {
  final List<StudentModel> students;
  final List<ExamModel> exams;
  final StageModel stage;

  const ExamGradesTable(
      {super.key,
      required this.students,
      required this.exams,
      required this.stage});

  @override
  State<ExamGradesTable> createState() => _ExamGradesTableState();
}

class _ExamGradesTableState extends State<ExamGradesTable> {
  @override
  Widget build(BuildContext context) {
    return AlkamarTable(
        tableData: TableData(
          headerHeightRatio: 0.088,
          rows: widget.students
              .map(
                (student) => TableRowItem(
                    student: student,
                    cells: List.generate(
                      student.grades?.length ?? 0,
                      (index) {
                        final grade = student.grades![index];
                        return CellItem(
                            content: '${grade.grade ?? '-'}',
                            onPressed: () {
                              try {
                                final exam = widget.exams[index];

                                showDialog(
                                    context: context,
                                    builder: (_) => BlocProvider.value(
                                          value: StudentCubit.instance(context),
                                          child: GradeDialog(
                                              student: student,
                                              exam: exam,
                                              grade: grade.grade),
                                        ));
                              } catch (e) {
                                rethrow;
                              }
                            },
                            color: grade.generateColor);
                      },
                    )),
              )
              .toList(),
          headers: widget.exams
              .map((exam) => HeaderItem(
                    title:
                        '${exam.title}\n ${exam.maxGrade} \n ${Methods.formatDate(exam.date)}',
                    onPressed: () {
                      Methods.navigateTo(context, ExamStatsScreen(exam: exam));
                    },
                  ))
              .toList(),
        ),
        stage: widget.stage);
  }
}
