import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class SearchStudentField extends StatelessWidget {
  const SearchStudentField({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: ColorManager.grey,
          ),
          Expanded(
              child: Center(
            child: TextWidget(
              label: 'ابحث عن طالب',
              color: ColorManager.grey,
            ),
          ))
        ],
      ),
    );
  }
}
