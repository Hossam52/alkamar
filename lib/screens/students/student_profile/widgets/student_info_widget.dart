import 'package:alqamar/cubits/student_cubit/student_profile_cubit.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/screens/students/student_profile/widgets/student_profile_base_section.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StudentInformation extends StatelessWidget {
  const StudentInformation({
    super.key,
    required this.student,
  });

  final StudentModel student;

  @override
  Widget build(BuildContext context) {
    return StudentProfileBaseSection(
      title: 'بيانات الطالب',
      child: Column(
        children: [
          _studentField('الكود', student.code),
          _studentField('الاسم', student.name),
          _studentField('المرحلة', student.stage),
          _studentField(
              'المجموعة', student.group_title ?? 'لم يتم تعيين مجموعة'),
          _studentField('تاريخ الالتحاق',
              Methods.formatDate(student.createdDate, appendYear: true)),
          _studentParentField('رقم الاب', student.fatherPhone),
          _studentParentField('رقم الام', student.motherPhone),
          _studentParentField('رقم الطالب', student.studentPhone),
          _studentParentField('رقم الواتس', student.whatsapp),
          _studentField('العنوان', student.address),
          _studentField('المدرسة', student.school),
          _studentField('مشاكل الطالب', student.problems),
          _studentField(
            'الحالة من المصاريف',
            student.paymentTitle,
            backgroundColor: student.last_payment?.paymentStatus.color,
          ),
          _studentField('حالة الطالب', student.studentStatusText),
        ],
      ),
    );
  }

  Widget _studentParentField(String key, String phone) {
    return Row(
      children: [
        Expanded(child: _studentField(key, phone, rtl: false)),
        Builder(builder: (context) {
          if (phone.isEmpty || phone.length < 10) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: 'ارسال',
              onPressed: () {
                if (student.student_status == false) {
                  Methods.showSnackBar(
                      context, 'هذا الطالب متوقف لا يمكنك ارسال الرسالة');
                  return;
                }
                launchWhatsapp(
                  phone,
                  StudentProfileCubit.instance(context).whtasappContent,
                );
              },
            ),
          );
        }),
      ],
    );
  }

  AuthTextField _studentField(String title, String value,
      {Color? backgroundColor, bool rtl = true}) {
    return AuthTextField(
      controller: TextEditingController(text: value),
      label: title,
      hint: '',
      enabled: false,
      validationRules: const [],
      backgroundColor: backgroundColor,
      isRtl: rtl,
    );
  }

  void launchWhatsapp(
    String phone,
    String message,
  ) async {
    if (phone.startsWith('01')) {
      phone = '+2$phone';
    }

    final url = 'https://wa.me/$phone?text=$message';

    await launchUrlString(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}
