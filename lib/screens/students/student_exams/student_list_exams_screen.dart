import 'package:alqamar/cubits/app_cubit/app_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/screens/students/student_exams/widgets/collective_exam_dialog.dart';
import 'package:alqamar/screens/students/student_exams/widgets/exams_table.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListExams extends StatefulWidget {
  const StudentListExams({Key? key, required this.stage}) : super(key: key);
  final StageModel stage;
  @override
  State<StudentListExams> createState() => _StudentListExamsState();
}

class _StudentListExamsState extends State<StudentListExams> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentCubit(widget.stage)..getStudentGrades(),
      child: Scaffold(
        appBar: AppBar(
          title: const TextWidget(
            label: 'درجات الامتحانات',
          ),
          actions: [
            !context.canPerformAction(context.loggedInPermissions?.exams,
                    create: true)
                ? const SizedBox.shrink()
                : Builder(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        text: 'مجمع',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                    value: StudentCubit.instance(context),
                                    child: const CollectiveExamDialog(),
                                  ));
                        },
                      ),
                    );
                  })
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: StudentBlocBuilder(
              builder: (context, state) {
                final studentCubit = StudentCubit.instance(context);
                final studentGrades = studentCubit.allStudentGrades;
                final totalStudents = studentCubit.totalGradesStudents;
                final exams = studentCubit.allExams;
                if (state is GetStudentGradesLoadingState) {
                  return const Center(child: DefaultLoader());
                }
                if (!studentCubit.hasLoadedExamRes) {
                  return CustomErrorWidget(
                    onPressed: () {
                      studentCubit.getStudentGrades();
                    },
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ExamGradesTable(
                        totalStudents: totalStudents,
                        students: studentGrades,
                        exams: exams,
                        stage: widget.stage,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
