import 'package:alqamar/models/student/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentQR extends StatelessWidget {
  const StudentQR({
    super.key,
    required this.student,
    required this.width,
  });

  final StudentModel student;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.network(
        student.qr_code_url,
        fit: BoxFit.fill,
        width: width * 0.3,
        height: width * 0.3,
        color: Colors.white,
      ),
    );
  }
}
