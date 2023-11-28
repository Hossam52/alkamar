import 'package:alqamar/cubits/app_cubit/app_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/screens/qr/qr_screen.dart';
import 'package:alqamar/screens/statistics/exam_statistics_screen.dart';
import 'package:alqamar/screens/students/student_exams/widgets/grade_dialog.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_data.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_widget.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamGradesTable extends StatefulWidget {
  final List<StudentModel> students;
  final List<ExamModel> exams;
  final StageModel stage;
  final int? totalStudents;

  const ExamGradesTable(
      {super.key,
      required this.students,
      required this.exams,
      required this.stage,
      this.totalStudents});

  @override
  State<ExamGradesTable> createState() => _ExamGradesTableState();
}

class _ExamGradesTableState extends State<ExamGradesTable> {
  @override
  Widget build(BuildContext context) {
    return AlkamarTable(
        loadMore: () {
          StudentCubit.instance(context).getStudentGrades();
        },
        tableData: TableData(
          headerHeightRatio: 0.12,
          totalItems: widget.totalStudents,
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

                                _confirm(context, exam,
                                    student: student, grade: grade);
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
              .map(
                (exam) => HeaderItem(
                  title:
                      '${exam.title}\n ${exam.maxGrade} \n ${Methods.formatDate(exam.date)}',
                  onPressed: () {
                    Methods.navigateTo(context, ExamStatsScreen(exam: exam));
                  },
                  action: !context.canPerformAction(
                          context.loggedInPermissions?.grades,
                          create: true)
                      ? null
                      : CustomButton(
                          text: 'اضافة',
                          onPressed: () async {
                            await Methods.navigateTo(
                                context,
                                BlocProvider.value(
                                    value: StudentCubit.instance(context),
                                    child: QrScreen(
                                      title: exam.title,
                                      actionsWidget: Container(),
                                      onManual: (studentCode) async {
                                        await _confirm(context, exam,
                                            studentCode: studentCode);
                                      },
                                      onQr: (studentid) async {
                                        await _confirm(context, exam,
                                            studentId: studentid);
                                      },
                                    )));
                          },
                        ),
                ),
              )
              .toList(),
        ),
        stage: widget.stage);
  }

  Future<dynamic> _confirm(BuildContext context, ExamModel exam,
      {GradeModel? grade,
      StudentModel? student,
      String? studentId,
      String? studentCode}) {
    return showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: StudentCubit.instance(context),
        child: GradeDialog(
          student: student,
          studentCode: studentCode,
          studetnId: studentId,
          exam: exam,
          grade: grade,
        ),
      ),
    );
  }
}
