import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: const TextWidget(
          label: 'لقد حدث خطأ اعادة المحاولة مجددا',
        ),
      ),
    );
  }
}
