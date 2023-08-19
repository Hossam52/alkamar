import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmAttendDialog extends StatefulWidget {
  const ConfirmAttendDialog(
      {super.key,
      this.studentId,
      this.studentCode,
      required this.actionsWidget})
      : assert(!(studentId == null && studentCode == null));
  final String? studentId;
  final String? studentCode;
  final Widget actionsWidget;

  @override
  State<ConfirmAttendDialog> createState() => ConfirmAttendDialogState();
}

class ConfirmAttendDialogState extends State<ConfirmAttendDialog> {
  @override
  void initState() {
    super.initState();
    StudentCubit.instance(context)
        .getStudentData(widget.studentId, widget.studentCode);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        StudentCubit.instance(context).removeSearchedStudent();
        return Future.value(true);
      },
      child: StudentBlocConsumer(listener: (context, state) {
        if (state is AttendStudentSuccessState) {
          Methods.showSuccessSnackBar(context, 'تم تسجيل الحضور بنجاح');
          Navigator.pop(context, true);
        }
        if (state is AttendStudentErrorState) {
          Methods.showSnackBar(context, state.error);
        }
        if (state is AddHomeworkStudentSuccessState) {
          Methods.showSuccessSnackBar(context, 'تم تسجيل الواجب بنجاح');
          Navigator.pop(context, true);
        }
        if (state is AddHomeworkStudentErrorState) {
          Methods.showSnackBar(context, state.error);
        }
      }, builder: (context, state) {
        final cubit = StudentCubit.instance(context);

        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0),
          backgroundColor: ColorManager.primary,
          title: const TextWidget(label: 'حول الطالب'),
          content: Builder(builder: (context) {
            if (state is GetStudentDataLoadingState) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultLoader(),
                ],
              );
            }
            if (cubit.errorOnSearchedStudent) {
              return CustomErrorWidget(onPressed: () {
                cubit.getStudentData(widget.studentId, widget.studentCode);
              });
            }
            final student = cubit.searchedStudent!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: cubit.searchedStudent != null
                      ? cubit.searchedStudent?.last_payment?.paymentStatus
                              .color ??
                          ColorManager.primary
                      : ColorManager.primary,
                  child: _rowItem('المصروفات: ', student.paymentTitle),
                ),
                _rowItem('اسم الطالب: ', student.name),
                _rowItem('الكود: ', student.code),
                _rowItem('المرحلة: ', student.stage),
              ],
            );
          }),
          actions: StudentCubit.instance(context).errorOnSearchedStudent
              ? null
              : [widget.actionsWidget],
        );
      }),
    );
  }

  Row _rowItem(String key, String val) {
    return Row(
      children: [
        TextWidget(label: key),
        TextWidget(label: val),
      ],
    );
  }
}
