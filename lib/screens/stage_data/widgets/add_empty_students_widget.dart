import 'package:alqamar/cubits/stage_cubit/stage_cubit.dart';
import 'package:alqamar/cubits/stage_cubit/stage_states.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:queen_validators/queen_validators.dart';

class AddEmptyStudentsWidget extends StatefulWidget {
  const AddEmptyStudentsWidget({super.key});

  @override
  State<AddEmptyStudentsWidget> createState() => _AddEmptyStudentsWidgetState();
}

class _AddEmptyStudentsWidgetState extends State<AddEmptyStudentsWidget> {
  final studentsCountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StageBlocConsumer(listener: (context, state) {
      if (state is AddEmptyStudentsErrorState) {
        Methods.showSnackBar(context, state.error);
      }
      if (state is AddEmptyStudentsSuccessState) {
        Methods.showSuccessSnackBar(context, 'تم اضافة الطلاب بنجاح');
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
                      controller: studentsCountController,
                      flex: 3,
                      label: 'عدد الطلاب',
                      hint: 'العدد',
                      validationRules: [IsNumber('يجب ان يكون الرقم صحيح')]),
                  if (state is AddEmptyStudentsLoadingState)
                    const DefaultLoader()
                  else
                    CustomButton(
                      text: 'اضف الطلاب',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          StageCubit.instance(context).addEmptyStudents(
                              int.parse(studentsCountController.text));
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
