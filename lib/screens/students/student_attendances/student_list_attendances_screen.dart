import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/screens/students/student_attendances/widgets/attendance_table.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListAttendances extends StatefulWidget {
  const StudentListAttendances({Key? key, required this.stage})
      : super(key: key);
  final StageModel stage;
  @override
  State<StudentListAttendances> createState() => _StudentListAttendancesState();
}

class _StudentListAttendancesState extends State<StudentListAttendances> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentCubit(widget.stage)..getStudentAttendances(),
      child: StudentBlocConsumer(
        listener: (context, state) {
          if (state is DownloadStudentQrsSuccessState) {
            Methods.showSuccessSnackBar(context, 'تم تحميل الملف بنجاح');
          }
          if (state is GenerateQrsSuccessState) {
            Methods.showSuccessSnackBar(
                context, 'تم التصدير بنجاح يمكنك التحميل');
          }
          if (state is GenerateQrsErrorState) {
            Methods.showSnackBar(context, state.error);
          }
          if (state is DownloadStudentQrsErrorState) {
            Methods.showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          final studentCubit = StudentCubit.instance(context);
          final attendances = studentCubit.allStudentAttendances;
          final lecs = studentCubit.allLectures;
          final totalStudents = studentCubit.totalAttendanceStudents;
          return Scaffold(
            appBar: AppBar(
              title: const TextWidget(
                label: 'قائمة الطلاب',
              ),
              actions: [
                _exportQrs(context, state),
                _downloadQrs(context, state),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Builder(
                  builder: (context) {
                    if (state is GetStudentAttendancesLoadingState) {
                      return const Center(child: DefaultLoader());
                    }
                    if (!studentCubit.hasLoadedAttendancesRes) {
                      return CustomErrorWidget(
                        onPressed: () {
                          studentCubit.getStudentAttendances();
                        },
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                            child: AttendanceTable(
                                students: attendances,
                                lecs: lecs,
                                totalStudents: totalStudents,
                                stage: widget.stage)),
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

  Widget _downloadQrs(BuildContext context, StudentStates state) {
    if (state is DownloadStudentQrsLoadingState) return const DefaultLoader();
    if (!StudentCubit.instance(context).hasQrError) {
      return IconButton(
          onPressed: () {
            StudentCubit.instance(context).downloadStudentQrs();
          },
          icon: const Icon(Icons.download));
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _exportQrs(BuildContext context, StudentStates state) {
    if (state is GenerateQrsLoadingState) return const DefaultLoader();

    if (StudentCubit.instance(context).selectedIdsContainData) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          text: 'تصدير',
          onPressed: () {
            StudentCubit.instance(context).generateQrs();
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
