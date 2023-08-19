import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AttendManual extends StatefulWidget {
  const AttendManual({
    super.key,
    required this.actionsWidget,
    required this.onLoad,
  });

  final Widget actionsWidget;
  final Future<void> Function(String? data) onLoad;

  @override
  State<AttendManual> createState() => _AttendManualState();
}

class _AttendManualState extends State<AttendManual> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AuthTextField(
                    inputType: TextInputType.number,
                    controller: controller,
                    focus: false,
                    label: 'الكود',
                    hint: "الكود",
                    validationRules: const [],
                  ),
                )
              ],
            ),
            CustomButton(
              text: 'تحضير يدوي',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  widget.onLoad(controller.text);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
