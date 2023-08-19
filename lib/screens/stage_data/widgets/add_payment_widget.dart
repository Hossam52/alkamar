import 'package:alqamar/cubits/stage_cubit/stage_cubit.dart';
import 'package:alqamar/cubits/stage_cubit/stage_states.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/screens/stage_data/widgets/add_exam_widget.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPaymentWidget extends StatefulWidget {
  const AddPaymentWidget({super.key});

  @override
  State<AddPaymentWidget> createState() => _AddPaymentWidgetState();
}

class _AddPaymentWidgetState extends State<AddPaymentWidget> {
  final titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return StageBlocConsumer(listener: (context, state) {
      if (state is CreatePaymentErrorState) {
        Methods.showSnackBar(context, state.error);
      }
      if (state is CreatePaymentSuccessState) {
        Methods.showSuccessSnackBar(context, 'تم اضافة المصروفات بنجاح');
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
                      label: 'اسم المصروفات',
                      hint: 'ادخل اسم المصروفات',
                      validationRules: const []),
                  CustomDateField(
                    onUpdateDate: (date) {
                      selectedDate = date;
                    },
                  ),
                  if (state is CreatePaymentLoadingState)
                    const DefaultLoader()
                  else
                    CustomButton(
                      text: 'اضف مصروفات',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          StageCubit.instance(context).createPayment(
                              titleController.text, selectedDate);
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
