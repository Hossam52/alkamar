import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/attend_status_enum.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/student_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmAttendActions extends StatefulWidget {
  const ConfirmAttendActions(
      {super.key, required this.lectureId, this.selectedGroupId});
  final String lectureId;
  final int? selectedGroupId;

  @override
  State<ConfirmAttendActions> createState() => _ConfirmAttendActionsState();
}

class _ConfirmAttendActionsState extends State<ConfirmAttendActions> {
  @override
  void initState() {
    if (widget.selectedGroupId == null) {
      groupId = StudentCubit.instance(context).searchedStudent!.group_id;
    } else {
      groupId = widget.selectedGroupId;
    }
    super.initState();
  }

  int? groupId;
  @override
  Widget build(BuildContext context) {
    return StudentBlocBuilder(
      builder: (context, state) {
        final cubit = StudentCubit.instance(context);
        if (state is AttendStudentLoadingState) return const DefaultLoader();

        return SingleChildScrollView(
          child: Column(
            children: [
              if (widget.selectedGroupId == null)
                StudentGroupWidget(
                    groupId: groupId,
                    onChangeGroup: (groupId) {
                      this.groupId = groupId;
                    }),
              _customMethod(
                  cubit: cubit,
                  attendStatus: AttendStatusEnum.attend,
                  icon: Icons.done),
              _sizedBox(),
              Row(
                children: [
                  Expanded(
                    child: _customMethod(
                        cubit: cubit,
                        attendStatus: AttendStatusEnum.forgot,
                        icon: Icons.close),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _customMethod(
                        cubit: cubit,
                        attendStatus: AttendStatusEnum.late,
                        icon: Icons.timer_sharp),
                  ),
                ],
              ),
              Divider(color: ColorManager.accentColor),
              _customMethod(
                  cubit: cubit,
                  attendStatus: AttendStatusEnum.cancel,
                  icon: Icons.cancel),
            ],
          ),
        );
      },
    );
  }

  CustomButton _customMethod({
    required StudentCubit cubit,
    required AttendStatusEnum attendStatus,
    required IconData icon,
  }) {
    return CustomButton(
      text: attendStatus.getAttendanceText,
      backgroundColor: attendStatus.getAttendanceColor,
      leadingIcon: Icon(icon),
      onPressed: () {
        cubit.attend(context, true, widget.lectureId, attendStatus, groupId);
      },
    );
  }

  Widget _sizedBox() {
    return SizedBox(height: 10.h);
  }
}
