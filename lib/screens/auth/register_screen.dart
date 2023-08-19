import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:queen_validators/queen_validators.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/auth_cubit/auth_states.dart';
import '../../shared/methods.dart';
import '../../shared/presentation/resourses/color_manager.dart';
import '../../shared/presentation/resourses/font_manager.dart';
import '../../shared/presentation/resourses/styles_manager.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/default_loader.dart';
import '../../widgets/text_widget.dart';
import 'edit/change_phone_screen.dart';
import 'login_screen.dart';
import 'widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool passwordVisible = false;
  bool passwordConfirmVisible = false;

  String _completePhoneNumber = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: !Navigator.canPop(context)
              ? null
              : CupertinoNavigationBarBackButton(
                  color: ColorManager.white,
                ),
        ),
        body: AuthBlocConsumer(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              Methods.showSnackBar(context, 'تم تسجيل حساب جديد بنجاح ');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
            if (state is RegisterErrorState) {
              Methods.showSuccessSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تسجيل حساب جديد.',
                            style: getBoldStyle(
                                fontSize: FontSize.s24,
                                color: ColorManager.white.withOpacity(0.8)),
                          ),
                          SizedBox(height: 30.h),
                          Text(
                            'اهلا بك في القمر',
                            style: getRegularStyle(
                                fontSize: FontSize.s24,
                                color: ColorManager.white.withOpacity(0.8)),
                          ),
                          SizedBox(height: 50.h),
                          AuthTextField(
                              label: 'الاسم',
                              hint: 'ادخل الاسم',
                              validationRules: const [],
                              inputType: TextInputType.name,
                              controller: nameController),
                          AuthTextField(
                              label: 'الايميل',
                              hint: 'ادخل الايميل ',
                              inputType: TextInputType.emailAddress,
                              validationRules: const [
                                IsEmail('هذا الايميل غير صحيح')
                              ],
                              controller: emailController),
                          AuthTextField.customTextField(
                            textField: PhoneField(
                              controller: phoneController,
                              onChange: (phoneNumber) =>
                                  _completePhoneNumber = phoneNumber,
                            ),
                            label: 'الهاتف',
                            controller: phoneController,
                          ),
                          SizedBox(height: 20.h),
                          StatefulBuilder(builder: (context, setState) {
                            return AuthTextField(
                                label: 'كلمة المرور',
                                password: passwordVisible,
                                onIconPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                hint: 'ادخل كلمة المرور',
                                validationRules: [
                                  PasswordConfirmationValidator(
                                      'يجب ان يكون كلمة المرور مطابقة للتأكيد',
                                      confirmPasswordController:
                                          passwordConfirmController),
                                  MinLength(6),
                                  MaxLength(50),
                                ],
                                controller: passwordController);
                          }),
                          StatefulBuilder(builder: (context, setState) {
                            return AuthTextField(
                                label: 'تأكيد كلمة المرور',
                                password: passwordConfirmVisible,
                                onIconPressed: () {
                                  setState(() {
                                    passwordConfirmVisible =
                                        !passwordConfirmVisible;
                                  });
                                },
                                hint: 'ادخل تأكيد كلمة المرور',
                                validationRules: const [],
                                controller: passwordConfirmController);
                          }),
                          AuthTextField.customTextField(
                            controller: TextEditingController(),
                            label: '',
                            textField: TextWidget(
                              fontSize: FontSize.s12,
                              label: '* يجب ان يكون كلمة المرور اكثر من 6 حروف',
                            ),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'لديك حساب؟',
                                style: getRegularStyle(),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                  child:
                                      const TextWidget(label: 'تسجيل الدخول')),
                            ],
                          ),
                          if (state is RegisterLoadingState)
                            const DefaultLoader()
                          else
                            CustomButton(
                              text: 'تسجيل',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  AuthCubit.instance(context).register(
                                    email: emailController.text,
                                    phone: _completePhoneNumber,
                                    name: nameController.text,
                                    password: passwordController.text,
                                    passwordConfirm:
                                        passwordConfirmController.text,
                                  );
                                }
                              },
                              backgroundColor: ColorManager.accentColor,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PasswordConfirmationValidator extends TextValidationRule {
  PasswordConfirmationValidator(super.error,
      {required this.confirmPasswordController});
  final TextEditingController confirmPasswordController;
  @override
  bool isValid(String input) {
    if (input == confirmPasswordController.text) return true;
    return false;
  }
}
