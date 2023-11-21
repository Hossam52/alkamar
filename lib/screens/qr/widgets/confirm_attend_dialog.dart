import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/attend_status_enum.dart';
import 'package:alqamar/screens/students/student_profile/student_profile_screen.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/shared/presentation/resourses/font_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
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

        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),

          backgroundColor: ColorManager.primary,
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Builder(builder: (context) {
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
                  Row(
                    children: [
                      const Expanded(
                        child: TextWidget(
                          label: 'حول الطالب',
                          fontSize: FontSize.s17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Center(
                        child: CustomButton(
                          text: 'ملف الطالب',
                          height: 40.h,
                          width: 70.w,
                          onPressed: () {
                            Methods.navigateTo(context,
                                StudentProfileScreen(studentId: student.id));
                          },
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                  _rowItem(
                      'مصروفات الشهر الحالي: ', student.currentPaymentTitle,
                      fontSize: 16.sp,
                      color:
                          student.current_month_payment?.paymentStatus.color),
                  _rowItem('مصروفات اخر شهر: ', student.lastPaymentTitle,
                      fontSize: 16.sp,
                      color: student.last_month_payment?.paymentStatus.color),
                  _rowItem('حالة اخر حصة: ', student.lastAttendanceTitle,
                      fontSize: 16.sp,
                      color: student.last_attendance?.attendStatusEnum
                          .getAttendanceColor),
                  _rowItem('اسم الطالب: ', student.name),
                  _rowItem('الكود: ', student.code),
                  _rowItem('المجموعة: ',
                      student.group_title ?? 'لم يتم تعيين مجموعة'),
                  _rowItem('المرحلة: ', student.stage),
                  StudentCubit.instance(context).errorOnSearchedStudent
                      ? const SizedBox.shrink()
                      : widget.actionsWidget
                ],
              );
            }),
          ),
          // actions: StudentCubit.instance(context).errorOnSearchedStudent
          //     ? null
          //     : [widget.actionsWidget],
        );
      }),
    );
  }

  Widget _rowItem(String key, String val, {double? fontSize, Color? color}) {
    return Container(
      color: color,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          TextWidget(
            label: key,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
          ),
          TextWidget(
            label: val,
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }
}
