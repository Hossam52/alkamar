import 'package:alqamar/cubits/stage_cubit/stage_cubit.dart';
import 'package:alqamar/cubits/stage_cubit/stage_states.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddGroupWidget extends StatefulWidget {
  const AddGroupWidget({super.key});

  @override
  State<AddGroupWidget> createState() => _AddGroupWidgetState();
}

class _AddGroupWidgetState extends State<AddGroupWidget> {
  final titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StageBlocConsumer(listener: (context, state) {
      if (state is AddGroupErrorState) {
        Methods.showSnackBar(context, state.error);
      }
      if (state is AddGroupSuccessState) {
        Methods.showSuccessSnackBar(context, 'تم اضافة المجموعة بنجاح');
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
                      label: 'اسم المجموعة',
                      hint: 'ادخل اسم المجموعة',
                      validationRules: const []),
                  if (state is AddGroupLoadingState)
                    const DefaultLoader()
                  else
                    CustomButton(
                      text: 'اضف مجموعة',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          StageCubit.instance(context)
                              .addGroup(titleController.text);
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
