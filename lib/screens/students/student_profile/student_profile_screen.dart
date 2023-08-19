import 'package:alqamar/cubits/student_cubit/student_profile_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/screens/students/add_student/add_student_screen.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_absecne_widget.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_grades_widget.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_homework_widget.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_info_widget.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_late_widget.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_qr_widget.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen(
      {Key? key, required this.studentId, required this.stageModel})
      : super(key: key);
  final int studentId;
  final StageModel? stageModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StudentProfileCubit(stageModel, studentId)..getStudentProfile(),
      child: StudentProfileBlocBuilder(builder: (context, state) {
        final cubit = StudentProfileCubit.instance(context);
        return Scaffold(
          appBar: AppBar(
            title: const TextWidget(label: 'بيانات طالب'),
            actions: [
              IconButton(
                  onPressed: () async {
                    final student = await Methods.navigateTo(
                        context,
                        AddStudentScreen(
                          student: cubit.student,
                        ));
                    if (student is StudentModel) {
                      cubit.setStudent = student;
                    }
                  },
                  icon: const Icon(Icons.edit)),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(builder: (context) {
              final cubit = StudentProfileCubit.instance(context);
              if (state is GetStudentProfileLoadingState) {
                return const DefaultLoader();
              }
              if (cubit.profileError) {
                return CustomErrorWidget(onPressed: () {
                  cubit.getStudentProfile();
                });
              }
              final width = MediaQuery.of(context).size.width;
              final student = cubit.student;
              final absence = cubit.absence;
              final late = cubit.late;
              final grades = cubit.grades;
              final homeworks = cubit.homeworks;
              return SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      StudentQR(student: student, width: width),
                      StudentInformation(student: student),
                      StudentAbsence(absence: absence),
                      StudentLate(late: late),
                      StudentHomework(homeworks: homeworks),
                      StudentGrades(grades: grades),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
