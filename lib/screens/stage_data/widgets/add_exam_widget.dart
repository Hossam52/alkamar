import 'package:alqamar/cubits/stage_cubit/stage_cubit.dart';
import 'package:alqamar/cubits/stage_cubit/stage_states.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:queen_validators/queen_validators.dart';

class AddExamWidget extends StatefulWidget {
  const AddExamWidget({super.key});

  @override
  State<AddExamWidget> createState() => _AddExamWidgetState();
}

class _AddExamWidgetState extends State<AddExamWidget> {
  final titleController = TextEditingController();
  final maxGradeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return StageBlocConsumer(listener: (context, state) {
      if (state is CreateExamErrorState) {
        Methods.showSnackBar(context, state.error);
      }
      if (state is CreateExamSuccessState) {
        Methods.showSuccessSnackBar(context, 'تم اضافة الامتحان بنجاح');
        Navigator.pop(context);
      }
    }, builder: (context, state) {
      return Form(
        key: formKey,
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: ColorManager.primary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
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
                  AuthTextField(
                      controller: maxGradeController,
                      flex: 3,
                      inputType: TextInputType.number,
                      label: 'الدرجة العظمي',
                      hint: 'ادخل الدرجة العظمى',
                      validationRules: [
                        IsNumber('يجب ان يكون ارقام فقط'),
                        MaxValue(1000, 'يجب ان تكون القيمة صغيرة عن 1000'),
                        MinValue(1, 'يجب ان تكون اكثر من 1'),
                      ]),
                  if (state is CreateExamLoadingState)
                    const DefaultLoader()
                  else
                    CustomButton(
                      text: 'اضف امتحان',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          StageCubit.instance(context).createExam(
                              titleController.text,
                              maxGradeController.text,
                              selectedDate);
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class CustomDateField extends StatefulWidget {
  const CustomDateField({super.key, required this.onUpdateDate});
  final void Function(DateTime?) onUpdateDate;
  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  final dateController = TextEditingController();
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return AuthTextField(
        controller: dateController,
        flex: 3,
        textField: TextButton(
            onPressed: () async {
              final res = await showDialog(
                context: context,
                builder: (context) => DatePickerDialog(
                  initialDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                ),
              );
              if (res != null) {
                setState(() {
                  widget.onUpdateDate(res);
                  selectedDate = res;
                });
              }
            },
            child: TextWidget(
                label: selectedDate == null
                    ? 'اختر تاريخ'
                    : Methods.formatDate(selectedDate!, appendYear: true))),
        label: 'تاريخ الامتحان',
        hint: 'ادخل تاريخ الامتحان',
        validationRules: const []);
  }
}
