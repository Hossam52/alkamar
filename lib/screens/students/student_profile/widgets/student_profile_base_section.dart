import 'package:alqamar/shared/presentation/resourses/font_manager.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentProfileBaseSection extends StatelessWidget {
  const StudentProfileBaseSection(
      {super.key, required this.child, required this.title});
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            label: title,
            fontSize: FontSize.s18,
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 18.w),
            child: child,
          ),
        ],
      ),
    );
  }
}
