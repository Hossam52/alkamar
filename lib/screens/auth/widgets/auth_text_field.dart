import '../../../shared/presentation/resourses/color_manager.dart';
import '../../../shared/presentation/resourses/styles_manager.dart';
import '../../../widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:queen_validators/queen_validators.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      required this.validationRules,
      this.flex,
      this.inputType = TextInputType.text,
      this.password = false,
      this.onIconPressed,
      this.textField,
      this.focus,
      this.enabled = true,
      this.isRequired = true,
      this.backgroundColor,
      this.isRtl = true});
  final int? flex;
  final Widget? textField;
  final TextEditingController controller;
  final bool password;
  final TextInputType inputType;
  final String label;
  final String hint;
  final List<TextValidationRule> validationRules;
  final void Function()? onIconPressed;
  final bool? focus;
  final bool enabled;
  final bool isRequired;
  final bool isRtl;
  final Color? backgroundColor;
  AuthTextField.customTextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.textField,
      this.inputType = TextInputType.text,
      this.password = false,
      this.hint = '',
      this.validationRules = const [],
      this.flex,
      this.onIconPressed,
      this.focus,
      this.enabled = true,
      this.backgroundColor,
      this.isRequired = true,
      this.isRtl = true});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(label,
                    style: getMediumStyle(color: ColorManager.white))),
            SizedBox(width: 20.w),
            Expanded(
              flex: flex ?? 4,
              child: Directionality(
                textDirection:
                    isRtl == true ? TextDirection.rtl : TextDirection.ltr,
                child: textField ??
                    CustomTextFormField(
                        backgroundColor: backgroundColor,
                        autoFocus: focus,
                        controller: controller,
                        isSecure: password,
                        type: inputType,
                        enabled: enabled,
                        hasBorder: true,
                        suffixIconColor: ColorManager.white,
                        suffixIcon: password
                            ? Icons.visibility_off
                            : onIconPressed != null
                                ? Icons.visibility
                                : null,
                        suffixPressed: onIconPressed,
                        borderColor: Colors.white54,
                        hint: hint,
                        validation: qValidator([
                          if (isRequired) IsRequired('هذا الحقل مطلوب'),
                          ...validationRules
                        ])),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
