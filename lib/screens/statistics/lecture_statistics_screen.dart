import 'package:alqamar/cubits/app_cubit/app_cubit.dart';
import 'package:alqamar/cubits/lecture_cubit/lecture_cubit.dart';
import 'package:alqamar/cubits/lecture_cubit/lecture_states.dart';
import 'package:alqamar/cubits/stage_cubit/stage_cubit.dart';
import 'package:alqamar/models/lecture/lecture_model.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/shared/presentation/resourses/font_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/groups_drop_down_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LectureStatsScreen extends StatefulWidget {
  const LectureStatsScreen({Key? key, required this.lecture}) : super(key: key);
  final LectureModel lecture;

  @override
  State<LectureStatsScreen> createState() => _LectureStatsScreenState();
}

class _LectureStatsScreenState extends State<LectureStatsScreen> {
  int? selectedGroupId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            LectureCubit(widget.lecture)..getLectureStatistics(),
        child: LectureBlocConsumer(listener: (context, state) {
          if (state is GetLectureStatisticsErrorState) {
            Methods.showSnackBar(context, state.error);
          }
        }, builder: (context, state) {
          final lecture = LectureCubit.instance(context).lecture;
          return Scaffold(
            appBar: AppBar(
              title: TextWidget(label: 'بيانات محاضرة ${lecture.title}'),
              actions: [
                if (context.canPerformAction(
                    context.loggedInPermissions?.lectures,
                    update: true))
                  IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return BlocProvider.value(
                                value: LectureCubit.instance(context),
                                child: _UpdateLecture(lecture: lecture),
                              );
                            });
                      }),
                if (context.canPerformAction(
                    context.loggedInPermissions?.lectures,
                    delete: true))
                  IconButton(
                    icon: Icon(Icons.delete, color: ColorManager.error),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                              value: LectureCubit.instance(context),
                              child: _DeleteLecture(lecture: lecture)));
                    },
                  ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8.0.w),
                child: ListView(
                  children: [
                    _ExamDetails(lec: lecture),
                    _GroupSelection(
                      selectedGroupId: selectedGroupId,
                      onChangeGroup: (id) {
                        selectedGroupId = id;
                      },
                    ),
                    CustomButton(
                      text: 'كل المجموعات',
                      onPressed: () {
                        selectedGroupId = null;
                        LectureCubit.instance(context).getLectureStatistics();
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final cubit = LectureCubit.instance(context);
                        if (state is GetLectureStatisticsLoadingState) {
                          return const DefaultLoader();
                        }
                        if (cubit.errorLoadingStats) {
                          return CustomErrorWidget(onPressed: () {
                            cubit.getLectureStatistics(
                                groupId: selectedGroupId);
                          });
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Center(
                                child: TextWidget(
                                    label: 'احصائيات المحاضرة',
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontSize.s18),
                              ),
                              ...cubit.lectureStats
                                  .map((stat) => Column(
                                        children: [
                                          _field('المجموعة',
                                              stat.group_title ?? 'الكل'),
                                          _field('عدد الحضور',
                                              '${stat.attends_count}'),
                                          _field('نسيان الكراسة ',
                                              '${stat.forgot_book_count}'),
                                          _field('عدد المتأخرين',
                                              '${stat.late_count}'),
                                          _field('عدد المتغيبين',
                                              '${stat.absence_count}'),
                                          _field('عدد المتوقفين',
                                              '${stat.disabled_count}'),
                                          _field('الاجمالي',
                                              '${stat.total_attendance_count} حضور من عدد ${stat.students_count} طالب منتظم'),
                                        ],
                                      ))
                                  .toList(),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  AuthTextField _field(String key, String value) {
    return AuthTextField(
      controller: TextEditingController(text: value),
      label: key,
      hint: '',
      validationRules: const [],
      enabled: false,
    );
  }
}

class _GroupSelection extends StatefulWidget {
  const _GroupSelection({this.selectedGroupId, required this.onChangeGroup});
  final int? selectedGroupId;
  final void Function(int?) onChangeGroup;

  @override
  State<_GroupSelection> createState() => _GroupSelectionState();
}

class _GroupSelectionState extends State<_GroupSelection> {
  int? groupId;
  @override
  void initState() {
    groupId = widget.selectedGroupId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GroupsDropDownWidget(
            selectedGroupId: widget.selectedGroupId,
            onChangeSelection: (groupId) {
              this.groupId = groupId;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
            text: 'اظهار',
            onPressed: () {
              LectureCubit.instance(context)
                  .getLectureStatistics(groupId: groupId);
            },
          ),
        ),
      ],
    );
  }
}

class _DeleteLecture extends StatelessWidget {
  const _DeleteLecture({
    required this.lecture,
  });

  final LectureModel lecture;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const TextWidget(
        label: 'حذف المحاضرة',
        color: Colors.red,
      ),
      backgroundColor: ColorManager.primary,
      content:
          TextWidget(label: 'هل انت متأكد من حذف (${lecture.title}) نهائيا؟'),
      actions: [
        LectureBlocConsumer(listener: (context, state) {
          if (state is DeleteLectureSuccessState) {
            Methods.showSuccessSnackBar(context, 'تم حذف المحاضرة بنجاح');
            Navigator.of(context)
              ..pop()
              ..pop();
          }
          if (state is DeleteLectureErrorState) {
            Methods.showSnackBar(context, state.error);
          }
        }, builder: (context, state) {
          if (state is DeleteLectureLoadingState) {
            return const DefaultLoader();
          }
          return CustomButton(
            text: 'حذف',
            onPressed: () {
              LectureCubit.instance(context).deleteLecture();
            },
            backgroundColor: ColorManager.error,
          );
        }),
        SizedBox(height: 10.h),
        CustomButton(
            text: 'الغاء',
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}

class _UpdateLecture extends StatefulWidget {
  const _UpdateLecture({
    required this.lecture,
  });

  final LectureModel lecture;

  @override
  State<_UpdateLecture> createState() => _UpdateLectureState();
}

class _UpdateLectureState extends State<_UpdateLecture> {
  final lectureTitle = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? lectureDate;

  @override
  void initState() {
    super.initState();
    lectureDate = widget.lecture.date;
    lectureTitle.text = widget.lecture.title;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorManager.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthTextField(
                    controller: lectureTitle,
                    flex: 3,
                    label: 'اسم المحاضرة',
                    hint: "ادخل اسم المحاضرة",
                    validationRules: const []),
                AuthTextField(
                    controller: lectureTitle,
                    flex: 3,
                    textField: TextButton(
                        onPressed: () async {
                          final res = await showDialog(
                            context: context,
                            builder: (context) => DatePickerDialog(
                              initialDate: widget.lecture.date,
                              lastDate:
                                  DateTime.now().add(const Duration(days: 30)),
                              firstDate: widget.lecture.date,
                            ),
                          );
                          if (res != null) {
                            setState(() {
                              lectureDate = res;
                            });
                          }
                        },
                        child: TextWidget(
                            label: lectureDate == null
                                ? 'اختر تاريخ'
                                : Methods.formatDate(lectureDate!,
                                    appendYear: true))),
                    label: 'تاريخ المحاضرة',
                    hint: 'ادخل تاريخ المحاضرة',
                    validationRules: const []),
                LectureBlocConsumer(listener: (context, state) {
                  if (state is UpdateLectureSuccessState) {
                    Methods.showSuccessSnackBar(
                        context, 'تم تحديث المحاضرة بنجاح');
                    Navigator.pop(context);
                  }
                  if (state is UpdateLectureErrorState) {
                    Methods.showSnackBar(context, state.error);
                  }
                }, builder: (context, state) {
                  if (state is UpdateLectureLoadingState) {
                    return const DefaultLoader();
                  }
                  return CustomButton(
                    text: 'تعديل المحاضرة',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (lectureDate == null) {
                          return Methods.showSnackBar(
                              context, 'يجب اختيار تاريخ المحاضرة اولا');
                        }
                        LectureCubit.instance(context).updateLecture(
                          title: lectureTitle.text,
                          date: lectureDate,
                        );
                      }
                    },
                  );
                })
              ],
            )),
      ),
    );
  }
}

class _ExamDetails extends StatelessWidget {
  const _ExamDetails({required this.lec});
  final LectureModel lec;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _rowItem('اسم المحاضرة', lec.title),
        _rowItem(
            'تاريخ المحاضرة', Methods.formatDate(lec.date, appendYear: true)),
      ],
    );
  }

  Widget _rowItem(String key, String value) {
    return Row(
      children: [
        Expanded(flex: 2, child: TextWidget(label: key)),
        Expanded(flex: 3, child: TextWidget(label: value)),
      ],
    );
  }
}
