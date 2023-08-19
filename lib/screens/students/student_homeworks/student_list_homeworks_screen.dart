import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/screens/students/student_homeworks/widgets/homeworks_table.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListHomeworks extends StatefulWidget {
  const StudentListHomeworks({Key? key, required this.stage}) : super(key: key);
  final StageModel stage;
  @override
  State<StudentListHomeworks> createState() => _StudentListHomeworksState();
}

class _StudentListHomeworksState extends State<StudentListHomeworks> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentCubit(widget.stage)..getStudentHomeworks(),
      child: StudentBlocConsumer(
        listener: (context, state) {},
        builder: (context, state) {
          final studentCubit = StudentCubit.instance(context);
          final students = studentCubit.allStudentHomeworks;
          final lecs = studentCubit.allHomeworks;
          return Scaffold(
            appBar: AppBar(
              title: const TextWidget(
                label: 'الواجبات',
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Builder(
                  builder: (context) {
                    if (state is GetStudentHomeworksLoadingState) {
                      return const Center(child: DefaultLoader());
                    }
                    if (!studentCubit.hasLoadedHomeworksRes) {
                      return CustomErrorWidget(
                        onPressed: () {
                          studentCubit.getStudentHomeworks();
                        },
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                            child: HomeworksTable(
                          students: students,
                          lecs: lecs,
                          stage: widget.stage,
                        )),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
