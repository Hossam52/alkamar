import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/screens/stage_data/widgets/add_exam_widget.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectiveExamDialog extends StatefulWidget {
  const CollectiveExamDialog({
    super.key,
  });

  @override
  State<CollectiveExamDialog> createState() => CollectiveExamDialogState();
}

class CollectiveExamDialogState extends State<CollectiveExamDialog> {
  Set<int> examsIds = {};
  final titleController = TextEditingController(text: 'مجمع');
  final formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    final exams = StudentCubit.instance(context).allExams;
    return Form(
      key: formKey,
      child: AlertDialog(
          backgroundColor: ColorManager.primary,
          insetPadding: EdgeInsets.all(4.w),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthTextField(
                    controller: titleController,
                    flex: 3,
                    label: 'اسم الامتحان',
                    hint: 'ادخل اسم الامتحان',
                    validationRules: const []),
                CustomDateField(
                  onUpdateDate: (date) {
                    selectedDate = date;
                  },
                ),
                ...exams.map((exam) {
                  final id = exam.id;
                  return StatefulBuilder(builder: (context, setState) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: CheckboxListTile.adaptive(
                        value: examsIds.contains(id),
                        onChanged: (bool? val) {
                          setState(() {
                            if (examsIds.contains(id)) {
                              examsIds.remove(id);
                            } else {
                              examsIds.add(id);
                            }
                          });
                        },
                        title: TextWidget(label: exam.title),
                      ),
                    );
                  });
                }).toList(),
                StudentBlocConsumer(listener: (_, state) {
                  if (state is AddCollectiveExamSuccessState) {
                    Navigator.pop(context);
                  }
                  if (state is AddCollectiveExamErrorState) {
                    Methods.showSnackBar(context, state.error);
                  }
                }, builder: (context, state) {
                  if (state is AddCollectiveExamLoadingState) {
                    return const DefaultLoader();
                  }
                  return CustomButton(
                    text: 'تجميع واضافة',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (selectedDate == null) {
                          Methods.showSnackBar(context, 'يجب اختيار التاريخ');
                          return;
                        }
                        if (examsIds.length < 2) {
                          Methods.showSnackBar(
                              context, 'يجب اختيار امتحانين علي الاقل');
                          return;
                        }
                        StudentCubit.instance(context).appendCollective(
                            examIds: examsIds,
                            date: selectedDate!,
                            title: titleController.text);
                        // Navigator.pop(context);
                      }
                    },
                  );
                })
              ],
            ),
          )),
    );
  }
}
