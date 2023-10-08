import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/exam/exam_model.dart';
import 'package:alqamar/models/grade/grade_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/shared/presentation/resourses/font_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/student_group_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:queen_validators/queen_validators.dart';

class GradeDialog extends StatefulWidget {
  const GradeDialog(
      {super.key,
      required this.student,
      required this.exam,
      this.grade,
      this.studentCode,
      this.studetnId});
  final StudentModel? student;
  final String? studentCode;
  final String? studetnId;
  final ExamModel exam;
  final GradeModel? grade;
  @override
  State<GradeDialog> createState() => GradeDialogState();
}

class GradeDialogState extends State<GradeDialog> {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller = TextEditingController(
        text:
            widget.grade?.grade == null ? '' : widget.grade?.grade.toString());
    if (widget.student == null) {
      StudentCubit.instance(context)
          .getStudentData(widget.studetnId, widget.studentCode);
    }
    selectedGroupId = widget.grade?.groupId;
    super.initState();
  }

  int? selectedGroupId;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Dialog(
        backgroundColor: ColorManager.primary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StudentBlocBuilder(
            builder: (context, state) {
              final cubit = StudentCubit.instance(context);
              if (widget.student == null &&
                  widget.studentCode == null &&
                  widget.studetnId == null) {
                return CustomErrorWidget(onPressed: () {
                  Navigator.pop(context);
                });
              }

              late StudentModel student;
              if (widget.student != null) {
                student = widget.student!;
              } else {
                if (state is GetStudentDataLoadingState) {
                  return const DefaultLoader();
                }
                if (state is GetStudentDataErrorState ||
                    cubit.errorOnSearchedStudent) {
                  return CustomErrorWidget(
                    onPressed: () {
                      cubit.getStudentData(
                          widget.studetnId, widget.studentCode);
                    },
                  );
                } else {
                  student = StudentCubit.instance(context).searchedStudent!;
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthTextField(
                    controller: controller,
                    label: 'الدرجة العظمي',
                    hint: '',
                    flex: 2,
                    textField: TextWidget(
                      label: widget.exam.maxGrade.toString(),
                      fontSize: FontSize.s14,
                    ),
                    validationRules: const [],
                    inputType: TextInputType.number,
                  ),
                  AuthTextField(
                    controller: controller,
                    label: 'الامتحان',
                    hint: '',
                    flex: 2,
                    textField: TextWidget(
                      label: widget.exam.title.toString(),
                      fontSize: FontSize.s14,
                    ),
                    validationRules: const [],
                    inputType: TextInputType.number,
                  ),
                  AuthTextField(
                    controller: controller,
                    label: 'الطالب',
                    hint: '',
                    flex: 2,
                    textField: TextWidget(
                      label: student.name.toString(),
                      fontSize: FontSize.s14,
                    ),
                    validationRules: const [],
                    inputType: TextInputType.number,
                  ),
                  StudentGroupWidget(
                      groupId: selectedGroupId,
                      onChangeGroup: (groupId) {
                        selectedGroupId = groupId;
                      }),
                  AuthTextField(
                    controller: controller,
                    label: 'الدرجة',
                    hint: 'ادخل الدرجة',
                    validationRules: [
                      IsNumber('يجب ان يتكون من ارقام فقط'),
                      GradeValidator('يجب ان تكون الدرجة اقل من الدرجة العظمي',
                          maxGrade: widget.exam.maxGrade),
                      GradePostiveValidator('يجب ان تكون قيمة موجبه')
                    ],
                    inputType: TextInputType.number,
                  ),
                  StudentBlocConsumer(
                    listener: (context, state) {
                      if (state is AddStudentGradeSuccessState) {
                        Methods.showSuccessSnackBar(
                            context, 'تم اضافة الدرجة بنجاح');
                        Navigator.pop(context);
                      }
                      if (state is AddStudentGradeErrorState) {
                        Methods.showSnackBar(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      if (state is AddStudentGradeLoadingState) {
                        return const DefaultLoader();
                      }
                      return CustomButton(
                        text: 'تسجيل الدرجة',
                        onPressed: () {
                          if (selectedGroupId == null) {
                            Methods.showSnackBar(
                                context, 'يجب اختيار الجروب اولا');
                            return;
                          }
                          if (formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            StudentCubit.instance(context).addStudentGrade(
                                student.id,
                                selectedGroupId,
                                num.tryParse(controller.text) ?? 0,
                                widget.exam);
                          }
                        },
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
}

class GradeValidator extends TextValidationRule {
  GradeValidator(super.error, {required this.maxGrade});
  final int maxGrade;
  @override
  bool isValid(String input) {
    final res = double.tryParse(input);
    if (res == null) return false;
    if (res <= maxGrade.toDouble()) return true;
    return false;
  }
}

class GradePostiveValidator extends TextValidationRule {
  GradePostiveValidator(
    super.error,
  );

  @override
  bool isValid(String input) {
    final res = double.tryParse(input);
    if (res == null) return false;
    if (res >= 0) return true;
    return false;
  }
}
