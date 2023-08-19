import 'package:alqamar/cubits/exam_cubit/exam_cubit.dart';
import 'package:alqamar/cubits/exam_cubit/exam_states.dart';
import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/models/exam/exam_statistics_model.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/screens/students/student_profile/student_profile_screen.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/shared/presentation/resourses/font_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/custom_table_defination_widget.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:queen_validators/queen_validators.dart';

class ExamStatsScreen extends StatelessWidget {
  const ExamStatsScreen({Key? key, required this.exam}) : super(key: key);
  final ExamModel exam;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamCubit(exam)..getExamStatistics(),
      child: ExamBlocBuilder(builder: (context, state) {
        final exam = ExamCubit.instance(context).exam;
        return Scaffold(
          appBar: AppBar(
            title: TextWidget(label: 'بيانات امتحان ${exam.title}'),
            actions: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return BlocProvider.value(
                            value: ExamCubit.instance(context),
                            child: _UpdateExam(exam: exam),
                          );
                        });
                  }),
              IconButton(
                icon: Icon(Icons.delete, color: ColorManager.error),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => BlocProvider.value(
                          value: ExamCubit.instance(context),
                          child: _DeleteExam(exam: exam)));
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8.0.w),
              child: ListView(
                children: [
                  _ExamDetails(exam: exam),
                  Builder(
                    builder: (context) {
                      final cubit = ExamCubit.instance(context);
                      if (state is GetExamStatisticsLoadingState) {
                        return const DefaultLoader();
                      }
                      if (cubit.errorLoadingStats) {
                        return CustomErrorWidget(onPressed: () {
                          cubit.getExamStatistics();
                        });
                      }
                      final stats = cubit.examStatistics;
                      final examAbsenceCount = cubit.examAbsenceCount;
                      final examTotalStudentsCount =
                          cubit.examTotalStudentsCount;
                      return Column(
                        children: [
                          _StatsButton(cubit: cubit),
                          _ExamStatsTable(
                              stats: stats,
                              examAbsenceCount: examAbsenceCount,
                              examTotalStudentsCount: examTotalStudentsCount),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _DeleteExam extends StatelessWidget {
  const _DeleteExam({
    super.key,
    required this.exam,
  });

  final ExamModel exam;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const TextWidget(
        label: 'حذف الامتحان',
        color: Colors.red,
      ),
      backgroundColor: ColorManager.primary,
      content: TextWidget(label: 'هل انت متأكد من حذف (${exam.title}) نهائيا؟'),
      actions: [
        ExamBlocConsumer(listener: (context, state) {
          if (state is DeleteExamSuccessState) {
            Methods.showSuccessSnackBar(context, 'تم حذف الامتحان بنجاح');
            Navigator.of(context)
              ..pop()
              ..pop();
          }
          if (state is DeleteExamErrorState) {
            Methods.showSnackBar(context, state.error);
          }
        }, builder: (context, state) {
          if (state is DeleteExamLoadingState) {
            return const DefaultLoader();
          }
          return CustomButton(
            text: 'حذف',
            onPressed: () {
              ExamCubit.instance(context).deleteExam();
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

class _UpdateExam extends StatefulWidget {
  const _UpdateExam({
    required this.exam,
  });

  final ExamModel exam;

  @override
  State<_UpdateExam> createState() => _UpdateExamState();
}

class _UpdateExamState extends State<_UpdateExam> {
  final examTitle = TextEditingController();
  final examMaxGrade = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? examDate;

  @override
  void initState() {
    super.initState();
    examDate = widget.exam.date;
    examTitle.text = widget.exam.title;
    examMaxGrade.text = widget.exam.maxGrade.toString();
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
                    controller: examTitle,
                    flex: 3,
                    label: 'اسم الامتحان',
                    hint: "ادخل اسم الامتحان",
                    validationRules: []),
                AuthTextField(
                    controller: examMaxGrade,
                    flex: 3,
                    label: 'الدرجة العظمى',
                    hint: "ادخل الدرجة العظمي",
                    validationRules: [
                      IsNumber('يجب ان يكون ارقام فقط'),
                      MaxValue(1000, 'يجب ان تكون القيمة صغيرة عن 1000'),
                      MinValue(1, 'يجب ان تكون اكثر من 1'),
                    ]),
                AuthTextField(
                    controller: examTitle,
                    flex: 3,
                    textField: TextButton(
                        onPressed: () async {
                          final res = await showDialog(
                            context: context,
                            builder: (context) => DatePickerDialog(
                              initialDate: widget.exam.date,
                              lastDate:
                                  DateTime.now().add(const Duration(days: 30)),
                              firstDate: widget.exam.date,
                            ),
                          );
                          if (res != null) {
                            setState(() {
                              examDate = res;
                            });
                          }
                        },
                        child: TextWidget(
                            label: examDate == null
                                ? 'اختر تاريخ'
                                : Methods.formatDate(examDate!,
                                    appendYear: true))),
                    label: 'تاريخ الامتحان',
                    hint: 'ادخل تاريخ الامتحان',
                    validationRules: const []),
                ExamBlocConsumer(listener: (context, state) {
                  if (state is UpdateExamSuccessState) {
                    Methods.showSuccessSnackBar(
                        context, 'تم تحديث الامتحان بنجاح');
                    Navigator.pop(context);
                  }
                  if (state is UpdateExamErrorState) {
                    Methods.showSnackBar(context, state.error);
                  }
                }, builder: (context, state) {
                  if (state is UpdateExamLoadingState) {
                    return const DefaultLoader();
                  }
                  return CustomButton(
                    text: 'تعديل الامتحان',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (examDate == null) {
                          return Methods.showSnackBar(
                              context, 'يجب اختيار تاريخ الامتحان اولا');
                        }
                        ExamCubit.instance(context).updateExam(
                          examName: examTitle.text,
                          maxGrade: num.tryParse(examMaxGrade.text),
                          examDate: examDate,
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

class _StatsButton extends StatefulWidget {
  const _StatsButton({
    required this.cubit,
  });

  final ExamCubit cubit;

  @override
  State<_StatsButton> createState() => _StatsButtonState();
}

class _StatsButtonState extends State<_StatsButton> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AuthTextField(
                controller: controller,
                label: 'التقسيم',
                hint: 'ادخل التقسيم',
                validationRules: [IsNumber('ادخل رقم صحيح')],
                inputType: TextInputType.number,
                focus: false),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomButton(
              text: 'اظهر الاحصائيات',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  widget.cubit.getExamStatistics(division: controller.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamStatsTable extends StatelessWidget {
  const _ExamStatsTable({
    required this.stats,
    required this.examAbsenceCount,
    required this.examTotalStudentsCount,
  });

  final List<ExamStatsModel> stats;
  final int examAbsenceCount;
  final int examTotalStudentsCount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          const Center(
            child: TextWidget(
                label: 'احصائيات الامتحان',
                fontWeight: FontWeight.bold,
                fontSize: FontSize.s18),
          ),
          AuthTextField(
            controller:
                TextEditingController(text: examAbsenceCount.toString()),
            label: 'عدد المتغيبين',
            hint: '',
            validationRules: const [],
            enabled: false,
          ),
          Table(
            border: TableBorder.all(color: ColorManager.accentColor),
            children: [
              TableRow(
                  decoration: BoxDecoration(
                      color: ColorManager.accentColor.withOpacity(0.8)),
                  children: [
                    _header('من'),
                    _header('الي'),
                    _header('العدد'),
                  ]),
              ...stats
                  .map((e) => TableRow(children: [
                        _content('${e.from}', stat: e),
                        _content('${e.to}', stat: e),
                        _content(e.students.length.toString(), stat: e),
                      ]))
                  .toList(),
              TableRow(children: [
                _content('عدد الطلاب'),
                _content(''),
                _content(examTotalStudentsCount.toString()),
              ])
            ],
          ),
        ],
      ),
    );
  }

  TableCell _header(String title) {
    return TableCell(
        child: Center(
            child: TextWidget(
      label: title,
      fontWeight: FontWeight.bold,
      fontSize: FontSize.s14,
    )));
  }

  TableCell _content(String title, {ExamStatsModel? stat}) {
    return TableCell(child: Builder(builder: (context) {
      return InkWell(
        onTap: () {
          if (stat != null) {
            showDialog(context: context, builder: (_) => _GradeStudents(stat));
          }
        },
        child: Padding(
          padding: EdgeInsets.all(6.0.w),
          child: Center(
              child: TextWidget(
            label: title,
            fontWeight: FontWeight.bold,
            fontSize: FontSize.s14,
          )),
        ),
      );
    }));
  }
}

class _GradeStudents extends StatelessWidget {
  const _GradeStudents(this.stat);
  final ExamStatsModel stat;

  @override
  Widget build(BuildContext context) {
    final students = stat.students;
    return Dialog(
        insetPadding: EdgeInsets.all(8.w),
        backgroundColor: ColorManager.primary,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: CustomTableDefinition(
              tableDefinition: TableDefinition(
                  headers: ['الكود', 'الاسم', 'الدرجة'],
                  rows: students
                      .map((e) => RowItem(
                              color: e.grade.generateColor,
                              onRowPressed: () {
                                Methods.navigateTo(
                                    context,
                                    StudentProfileScreen(
                                        studentId: e.student.id,
                                        stageModel: null));
                              },
                              cells: [
                                e.student.code,
                                e.student.name,
                                e.grade.gradeFromMaxGrade
                              ]))
                      .toList()),
            ),
          ),
        )

        // ListView.builder(itemBuilder: (_,index){
        //   final student = students[index].student;
        //   final grade = students[index].grade;
        //   return ListTile(title: TextWidget(label: student.student.),)
        // }),
        );
  }
}

class _ExamDetails extends StatelessWidget {
  const _ExamDetails({required this.exam});
  final ExamModel exam;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _rowItem('اسم الامتحان', exam.title),
        _rowItem('تاريخ الامتحان', Methods.formatDate(exam.date)),
        _rowItem('درجة الامتحان العظمي', exam.maxGrade.toString()),
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
