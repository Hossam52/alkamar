import 'package:alqamar/cubits/app_cubit/app_cubit.dart';
import 'package:alqamar/cubits/stage_cubit/stage_cubit.dart';
import 'package:alqamar/cubits/stage_cubit/stage_states.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/screens/stage_data/widgets/add_group_widget.dart';
import 'package:alqamar/screens/stage_data/widgets/add_payment_widget.dart';
import 'package:alqamar/screens/students/student_homeworks/student_list_homeworks_screen.dart';
import 'package:alqamar/screens/qr/qr_screen.dart';
import 'package:alqamar/screens/search/student_search_screen.dart';
import 'package:alqamar/screens/stage_data/widgets/add_exam_widget.dart';
import 'package:alqamar/screens/stage_data/widgets/add_lecture_widget.dart';
import 'package:alqamar/screens/students/add_student/add_student_screen.dart';
import 'package:alqamar/screens/students/student_attendances/student_list_attendances_screen.dart';
import 'package:alqamar/screens/students/student_exams/student_list_exams_screen.dart';
import 'package:alqamar/screens/students/student_payments/student_payments_screen.dart';
import 'package:alqamar/screens/students/student_profile/student_profile_screen.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/shared/presentation/resourses/font_manager.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StageDataScreen extends StatefulWidget {
  const StageDataScreen({Key? key, required this.stage}) : super(key: key);
  final StageModel stage;

  @override
  State<StageDataScreen> createState() => _StageDataScreenState();
}

class _StageDataScreenState extends State<StageDataScreen> {
  @override
  void initState() {
    StageCubit.instance(context).setStage = widget.stage;
    getAllGroups();
    super.initState();
  }

  Future<void> getAllGroups() async {
    StageCubit.instance(context).getGroups();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint((MediaQuery.of(context).size.width * 0.006).toString());
    return Scaffold(
      appBar: AppBar(title: TextWidget(label: widget.stage.fullTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StageBlocBuilder(
            builder: (context, state) {
              if (state is GetGroupsLoadingState) {
                return const DefaultLoader();
              }
              if (state is GetGroupsErrorState) {
                return CustomErrorWidget(onPressed: getAllGroups);
              }
              return GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.w),
                children: [
                  _CustomItem(
                    title: 'بحث عن طالب',
                    icon: Icons.search,
                    onPressed: () {
                      Methods.navigateTo(
                          context, StudentSearchScreen(stage: widget.stage));
                    },
                  ),
                  if (AppCubit.instance(context)
                          .permissions
                          ?.students
                          ?.create ??
                      false)
                    _CustomItem(
                      title: 'تسجيل طالب جديد',
                      icon: Icons.person_add_alt,
                      onPressed: () {
                        Methods.navigateTo(
                            context,
                            BlocProvider.value(
                              value: StageCubit.instance(context),
                              child: const AddStudentScreen(),
                            ));
                      },
                    ),
                  if (AppCubit.instance(context)
                          .permissions
                          ?.attendances
                          ?.view ??
                      false)
                    _CustomItem(
                      title: 'قائمة الطلاب',
                      icon: Icons.list,
                      onPressed: () {
                        Methods.navigateTo(
                            context,
                            StudentListAttendances(
                              stage: widget.stage,
                            ));
                      },
                    ),
                  if (AppCubit.instance(context).permissions?.grades?.view ??
                      false)
                    _CustomItem(
                      title: 'درجات الامتحانات',
                      icon: Icons.format_list_numbered_rtl_sharp,
                      onPressed: () {
                        Methods.navigateTo(
                            context,
                            StudentListExams(
                              stage: widget.stage,
                            ));
                      },
                    ),
                  if (AppCubit.instance(context)
                          .permissions
                          ?.student_payments
                          ?.view ??
                      false)
                    _CustomItem(
                      title: 'المصروفات',
                      icon: Icons.money,
                      onPressed: () {
                        _showDialog(
                          context,
                          StudentPaymentsScreen(stage: widget.stage),
                        );
                      },
                    ),
                  if (AppCubit.instance(context).permissions?.homeworks?.view ??
                      false)
                    _CustomItem(
                      title: 'الواجبات',
                      icon: Icons.edit_document,
                      onPressed: () {
                        _showDialog(
                          context,
                          StudentListHomeworks(stage: widget.stage),
                        );
                      },
                    ),
                  if (AppCubit.instance(context)
                          .permissions
                          ?.lectures
                          ?.create ??
                      false)
                    _CustomItem(
                      title: 'إضافة محاضرة',
                      icon: Icons.add,
                      onPressed: () {
                        _showDialog(context, const AddLectureWidget());
                      },
                    ),
                  if (AppCubit.instance(context).permissions?.exams?.create ??
                      false)
                    _CustomItem(
                      title: 'إضافة امتحان',
                      icon: Icons.add,
                      onPressed: () {
                        _showDialog(context, const AddExamWidget());
                      },
                    ),
                  if (AppCubit.instance(context)
                          .permissions
                          ?.payments
                          ?.create ??
                      false)
                    _CustomItem(
                      title: 'إضافة مصروفات شهر',
                      icon: Icons.add,
                      onPressed: () {
                        _showDialog(context, const AddPaymentWidget());
                      },
                    ),
                  if (AppCubit.instance(context)
                          .permissions
                          ?.lectures
                          ?.create ??
                      false)
                    _CustomItem(
                      title: 'إضافة مجموعة جديدة',
                      icon: Icons.add,
                      onPressed: () {
                        _showDialog(context, const AddGroupWidget());
                      },
                    ),
                  _CustomItem(
                    title: 'بحث بال QR',
                    icon: Icons.image,
                    onPressed: () {
                      _showDialog(
                        context,
                        QrScreen(
                          title: 'بحث بال QR',
                          showManual: false,
                          onManual: (val) async {},
                          onQr: (val) async {
                            if (val == null || int.tryParse(val) == null) {
                              Methods.showSnackBar(context, 'خطأ في ال QR');
                              return;
                            }
                            await Methods.navigateTo(
                                context,
                                StudentProfileScreen(
                                  studentId: int.parse(val),
                                ));
                          },
                          actionsWidget: Container(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context, Widget child) {
    return showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
            value: StageCubit.instance(context), child: child);
      },
    );
  }
}

class _CustomItem extends StatelessWidget {
  const _CustomItem({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.color,
  });
  final String title;
  final IconData icon;
  final Color? color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: color ?? ColorManager.accentColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.h,
              color: ColorManager.white,
            ),
            Center(
                child: TextWidget(
              textAlign: TextAlign.center,
              label: title,
              fontSize: FontSize.s16,
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
      ),
    );
  }
}
