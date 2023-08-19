import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/homework_status_enum.dart';
import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/screens/qr/qr_screen.dart';
import 'package:alqamar/screens/qr/widgets/confirm_attend_dialog.dart';
import 'package:alqamar/screens/statistics/lecture_statistics_screen.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_data.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_widget.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';

class HomeworksTable extends StatefulWidget {
  final List<StudentModel> students;
  final List<LectureModel> lecs;
  final StageModel stage;

  const HomeworksTable(
      {super.key,
      required this.students,
      required this.lecs,
      required this.stage});

  @override
  State<HomeworksTable> createState() => _HomeworksTableState();
}

class _HomeworksTableState extends State<HomeworksTable> {
  @override
  Widget build(BuildContext context) {
    return AlkamarTable(
      stage: widget.stage,
      tableData: TableData(
        rows: _studentRows(context),
        headers: _headers(context),
      ),
    );
  }

  List<HeaderItem> _headers(BuildContext context) {
    return widget.lecs
        .map((lec) => HeaderItem(
              title: '${lec.title}\n ${Methods.formatDate(lec.date)}',
              onPressed: () {
                Methods.navigateTo(context, LectureStatsScreen(lecture: lec));
              },
              action: _CustomStoreHomework(lec: lec),
            ))
        .toList();
  }

  List<TableRowItem> _studentRows(BuildContext context) {
    return widget.students
        .map(
          (student) => TableRowItem(
              student: student,
              cells: List.generate(
                student.homeworks?.length ?? 0,
                (index) {
                  final homework = student.homeworks![index];

                  return CellItem(
                      content: homework.homeworkStatusEnum.getHomeworkText,
                      onPressed: () {
                        try {
                          final lecture = widget.lecs[index];
                          showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                  value: StudentCubit.instance(context),
                                  child: ConfirmAttendDialog(
                                    studentId: student.id.toString(),
                                    actionsWidget: _ConfirmHomeworkActions(
                                        lectureId: lecture.id.toString()),
                                  )));
                        } on Exception {
                          //
                        }
                      },
                      color: homework.homeworkStatusEnum.getHomeworkColor);
                },
              )),
        )
        .toList();
  }
}

class _CustomStoreHomework extends StatelessWidget {
  const _CustomStoreHomework({required this.lec});
  final LectureModel lec;
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'تسجيل',
      onPressed: () async {
        await Methods.navigateTo(
            context,
            BlocProvider.value(
                value: StudentCubit.instance(context),
                child: QrScreen(
                  title: lec.title,
                  actionsWidget:
                      _ConfirmHomeworkActions(lectureId: lec.id.toString()),
                  onManual: (studentCode) async {
                    await showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                            value: StudentCubit.instance(context),
                            child: _confirm(studentCode: studentCode)));
                  },
                  onQr: (studentid) async {
                    await showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                            value: StudentCubit.instance(context),
                            child: _confirm(studentId: studentid)));
                  },
                )));
        StudentCubit.instance(context).getStudentHomeworks();
      },
    );
  }

  ConfirmAttendDialog _confirm({String? studentId, String? studentCode}) {
    return ConfirmAttendDialog(
      studentCode: studentCode,
      studentId: studentId,
      actionsWidget: _ConfirmHomeworkActions(lectureId: lec.id.toString()),
    );
  }
}

class _ConfirmHomeworkActions extends StatelessWidget {
  const _ConfirmHomeworkActions({required this.lectureId});
  final String lectureId;
  @override
  Widget build(BuildContext context) {
    return StudentBlocConsumer(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = StudentCubit.instance(context);
        if (state is AddHomeworkStudentLoadingState) {
          return const DefaultLoader();
        }

        return Column(
          children: [
            _actionButton(cubit,
                homeworkStatus: HomeworkStatusEnum.done, icon: Icons.done),
            _sizedBox(),
            Row(
              children: [
                Expanded(
                  child: _actionButton(cubit,
                      homeworkStatus: HomeworkStatusEnum.notDone,
                      icon: Icons.close),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _actionButton(cubit,
                      homeworkStatus: HomeworkStatusEnum.incomplete,
                      icon: Icons.timer),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  CustomButton _actionButton(StudentCubit cubit,
      {required HomeworkStatusEnum homeworkStatus, required IconData icon}) {
    return CustomButton(
      text: homeworkStatus.getHomeworkText,
      backgroundColor: homeworkStatus.getHomeworkColor,
      leadingIcon: Icon(icon),
      onPressed: () {
        cubit.addHomeWork(lectureId, homeworkStatus);
      },
    );
  }

  Widget _sizedBox() {
    return SizedBox(height: 10.h);
  }
}
