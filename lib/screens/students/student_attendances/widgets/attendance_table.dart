import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/student_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/models/attend_status_enum.dart';
import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/screens/qr/qr_screen.dart';
import 'package:alqamar/screens/qr/widgets/confirm_attend_dialog.dart';
import 'package:alqamar/screens/statistics/lecture_statistics_screen.dart';
import 'package:alqamar/screens/students/student_attendances/widgets/confirm_attend_actions.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_data.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_widget.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceTable extends StatefulWidget {
  final List<StudentModel> students;
  final List<LectureModel> lecs;
  final StageModel stage;
  final int? totalStudents;

  const AttendanceTable(
      {super.key,
      required this.students,
      required this.lecs,
      required this.stage,
      this.totalStudents});

  @override
  State<AttendanceTable> createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AlkamarTable(
            stage: widget.stage,
            tableData: TableData(
              hasCheckbox: true,
              rows: _rows().toList(),
              headers: _headers(context).toList(),
              totalItems: widget.totalStudents,
            ),
            loadMore: () {
              StudentCubit.instance(context).getStudentAttendances();
            },
          ),
        ),
        // CustomButton(
        //   text: 'التالي',
        //   onPressed: () {
        //     StudentCubit.instance(context).getStudentAttendances();
        //   },
        // )
      ],
    );
  }

  Iterable<HeaderItem> _headers(BuildContext context) {
    return widget.lecs.map((lec) => HeaderItem(
        title: '${lec.title}\n ${Methods.formatDate(lec.date)}',
        onPressed: () {
          Methods.navigateTo(context, LectureStatsScreen(lecture: lec));
        },
        action: _CustomAttendButton(lec: lec)));
  }

  Iterable<TableRowItem> _rows() {
    return widget.students.map(
      (student) => TableRowItem(
          student: student,
          cells: List.generate(
            student.attendances?.length ?? 0,
            (index) {
              final attendance = student.attendances![index];
              String attendString = attendance.group == null
                  ? ''
                  : '\n${attendance.group?.title}';
              return CellItem(
                  content: attendance.attendStatusEnum.getAttendanceText +
                      attendString,
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: StudentCubit.instance(context),
                        child: ConfirmAttendDialog(
                          studentId: student.id.toString(),
                          actionsWidget: ConfirmAttendActions(
                              lectureId: widget.lecs[index].id.toString()),
                        ),
                      ),
                    );
                  },
                  color: attendance.attendStatusEnum.getAttendanceColor);
            },
          )),
    );
  }
}

class _CustomAttendButton extends StatelessWidget {
  const _CustomAttendButton({required this.lec});
  final LectureModel lec;
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'تحضير',
      onPressed: () async {
        final groupId = await showDialog<int?>(
            context: context, builder: (_) => const _SelectGroup());
        if (groupId != null) {
          // ignore: use_build_context_synchronously
          await Methods.navigateTo(
              context,
              BlocProvider.value(
                  value: StudentCubit.instance(context),
                  child: QrScreen(
                    title: lec.title,
                    actionsWidget: ConfirmAttendActions(
                      lectureId: lec.id.toString(),
                      selectedGroupId: groupId,
                    ),
                    onManual: (studentCode) async {
                      await showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                              value: StudentCubit.instance(context),
                              child: _confirm(
                                  studentCode: studentCode, groupId: groupId)));
                    },
                    onQr: (studentid) async {
                      await showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                              value: StudentCubit.instance(context),
                              child: _confirm(
                                  studentId: studentid, groupId: groupId)));
                    },
                  )));
          // StudentCubit.instance(context).getStudentAttendances();
        }
      },
    );
  }

  ConfirmAttendDialog _confirm(
      {String? studentId, String? studentCode, int? groupId}) {
    return ConfirmAttendDialog(
      studentCode: studentCode,
      studentId: studentId,
      actionsWidget: ConfirmAttendActions(
        lectureId: lec.id.toString(),
        selectedGroupId: groupId,
      ),
    );
  }
}

class _SelectGroup extends StatefulWidget {
  const _SelectGroup();

  @override
  State<_SelectGroup> createState() => _SelectGroupState();
}

class _SelectGroupState extends State<_SelectGroup> {
  int? groupId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorManager.primary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            StudentGroupWidget(onChangeGroup: (groupId) {
              this.groupId = groupId;
            }),
            SizedBox(height: 20.h),
            CustomButton(
              text: 'اختيار الجروب',
              onPressed: () {
                if (groupId == null) {
                  Methods.showSnackBar(context, 'يجب اختيار الجروب اولا');
                  return;
                }
                Navigator.pop(context, groupId);
              },
            )
          ],
        ),
      ),
    );
  }
}
